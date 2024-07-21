package matrix

import (
	"github.com/gdamore/tcell/v2"
	"math/rand"
	"os"
	"strings"
	"time"
)

func DigitalRain(hasError <-chan struct{}, rainDone chan<- struct{}) {
	defer close(rainDone)

	// init screen
	s, _ := tcell.NewScreen()
	_ = s.Init()
	defStyle := tcell.StyleDefault.Background(tcell.ColorReset).Foreground(tcell.ColorGreen)
	s.SetStyle(defStyle)
	s.Clear()

	quit := func() {
		s.Fini()
		os.Exit(0)
	}

	nodes := make([]node, 0, 100)
	width, height := s.Size()
	columns := initColumns(width, height)
	startTime := time.Now()

outer:
	for {
		select {
		case <-hasError:
			s.Fini()
			break outer
		default:
			// 刷新率
			time.Sleep(24 * time.Millisecond)
		}

		for _, col := range columns {
			// 让计时器减一,  计时器为 0 时产生新节点,  并重置计时器
			if col.Timer == 0 {
				n := col.spawnNode(col.X, height)
				nodes = append(nodes, n)
			}
			col.Timer -= 1
		}

		// 绘制节点,  并把节点下移一行
		for i := range nodes {
			drawNode(&nodes[i], s, defStyle)
			nodes[i].Y++
		}

		nodes = filter(nodes, func(n node) bool {
			return n.Y < height+1
		})

		// 打印横幅
		banner := []string{
			" ------------------------------------------------------------------ ",
			"                                                                    ",
			"               MyKeymap config server is running...                 ",
			"                                                                    ",
			" ------------------------------------------------------------------ ",
		}
		style := defStyle.Foreground(tcell.ColorWhite)
		for index, line := range banner {
			// 按一定速度打印第三行文字
			if index == 2 {
				text := strings.TrimLeft(line, " ")
				prefix := line[:len(line)-len(text)]
				distance := time.Since(startTime).Milliseconds() / 50
				text2 := text[:distance%int64(len(text))]
				suffix := strings.Repeat(" ", len(line)-len(prefix)-len(text2))
				line = prefix + text2 + suffix
			}
			drawText(s, 24, 5+index, 100, 100, style, line)
		}

		// Update screen
		s.Show()

		// Poll event
		if s.HasPendingEvent() {
			ev := s.PollEvent()

			// Process event
			switch ev := ev.(type) {
			case *tcell.EventResize:
				s.Sync()
				width, height = s.Size()
				columns = initColumns(width, height)
			case *tcell.EventKey:
				if ev.Key() == tcell.KeyEscape || ev.Key() == tcell.KeyCtrlC {
					quit()
				}
			}
		}
	}
}

func drawText(s tcell.Screen, x1, y1, x2, y2 int, style tcell.Style, text string) {
	// To draw text more easily, define a render function.
	row := y1
	col := x1
	for _, r := range []rune(text) {
		s.SetContent(col, row, r, nil, style)
		col++
		// col 在 x2 处换行
		if col >= x2 {
			row++
			col = x1
		}
		// 超出的文本不展示
		if row > y2 {
			break
		}
	}
}

func filter(nodes []node, f func(node) bool) []node {
	var result []node
	for i := range nodes {
		if f(nodes[i]) {
			result = append(result, nodes[i])
		}
	}
	return result
}

func drawNode(n *node, s tcell.Screen, style tcell.Style) {

	character := ' '
	color := tcell.ColorGreen

	// 1/2 节点是纯绿色,  1/2 节点带彩色,
	if n.Type == writer {
		character = getChar()
		if n.Colored {
			color = tcell.ColorYellow
		}
	}

	s.SetContent(n.X, n.Y, character, nil, style.Foreground(color))

	if n.Colored {
		if n.LastChar != 0 {
			// 三分之一的概率是亮绿色
			if rand.Intn(100) < 33 {
				color = tcell.Color46
			} else {
				color = tcell.ColorGreen
			}
			// 彩色节点的上一个格子需要从彩色改回绿色
			s.SetContent(n.X, n.Y-1, character, nil, style.Foreground(color))
		}
		n.LastChar = character
	}
}

func getChar() rune {
	const a = `ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ1234567890`
	const b = `1234567890-=*_+|:<>"-=*_+|:<>"-=*_+|:<>"-=*_+|:<>"`
	var charSet = []rune(a + b)
	return charSet[rand.Intn(len(charSet))]
}

func initColumns(width, height int) []*column {
	columns := make([]*column, 0, 100)
	for i := 0; i < width; i += 5 {
		col := column{
			Timer: 1 + rand.Intn(height-1),
			X:     i,
		}
		columns = append(columns, &col)
	}
	return columns
}

func (c *column) spawnNode(x, rowCount int) node {

	nt := eraser
	colored := false
	c.Timer = 1 + rand.Intn(rowCount-1)

	if c.NextNodeType == writer {
		nt = writer
		if rand.Intn(2) == 0 {
			colored = true
		}
		c.Timer = 3 + rand.Intn(rowCount-6)
		c.NextNodeType = eraser
	} else {
		c.NextNodeType = writer
	}

	return node{
		X:       x,
		Type:    nt,
		Colored: colored,
	}
}

type nodeType int

const (
	writer nodeType = iota
	eraser
)

type node struct {
	X        int
	Y        int
	Type     nodeType
	Colored  bool
	LastChar rune
}

type column struct {
	X            int
	Timer        int
	NextNodeType nodeType
}
