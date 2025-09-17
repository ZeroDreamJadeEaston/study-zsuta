import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.util.Arrays;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

public class SkyShooterGame extends JPanel {
    public static final int WIDTH = 400; // 面板宽
    public static BufferedImage background;
    public static BufferedImage MainFighter0;
    public static BufferedImage MainFighter1;
    public static BufferedImage start;
    public static BufferedImage pause;
    public static BufferedImage gameover;
    public static BufferedImage ScoreEnemyPlane;
    public static BufferedImage HoneyBee;
    public static BufferedImage Projectile;

    private int score = 0; // 得分
    private static final int START = 0;
    private static final int PAUSE = 2;
    private static final int RUNNING = 1;
    private static final int GAME_OVER = 3;
    private int state;

    private Projectile[] Projectiles = {}; // 子弹数组
    public static BufferedImage honeyBee;
    public static BufferedImage enemyPlane;
    private Timer timer; // 定时器
    private int intervel = 1000 / 100; // 时间间隔(毫秒)
    private FlyingEntity[] flyings = {}; // 敌机数组
    public static final int HEIGHT = 654; // 面板高
    public static BufferedImage projectile;
    public static BufferedImage mainFighter0;
    public static BufferedImage mainFighter1;
    public static BufferedImage scoreEnemyPlane;
    private MainFighter MainFighter = new MainFighter(); // 英雄机

    static {
        try {
            background = ImageIO.read(SkyShooterGame.class.getResource("background.png"));
            start = ImageIO.read(SkyShooterGame.class.getResource("start.png"));
            enemyPlane = ImageIO.read(SkyShooterGame.class.getResource("EnemyPlane.png"));
            HoneyBee = ImageIO.read(SkyShooterGame.class.getResource("HoneyBee.png"));
            Projectile = ImageIO.read(SkyShooterGame.class.getResource("Projectile.png"));
            MainFighter0 = ImageIO.read(SkyShooterGame.class.getResource("MainFighter0.png"));
            MainFighter1 = ImageIO.read(SkyShooterGame.class.getResource("MainFighter1.png"));
            pause = ImageIO.read(SkyShooterGame.class.getResource("pause.png"));
            gameover = ImageIO.read(SkyShooterGame.class.getResource("gameover.png"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 画游戏状态
    public void paintState(Graphics g) {
        switch (state) {
            case START:
                g.drawImage(start, 0, 0, null);
                break;
            case PAUSE:
                g.drawImage(pause, 0, 0, null);
                break;
            case GAME_OVER:
                g.drawImage(gameover, 0, 0, null);
                break;
        }
    }

    // 画子弹
    public void paintProjectiles(Graphics g) {
        for (Projectile b : Projectiles) {
            g.drawImage(b.getImage(), b.getX() - b.getWidth() / 2, b.getY(), null);
        }
    }

    // 画飞行物
    public void paintFlyingEntitys(Graphics g) {
        for (FlyingEntity f : flyings) {
            g.drawImage(f.getImage(), f.getX(), f.getY(), null);
        }
    }

    // 画
    @Override
    public void paint(Graphics g) {
        g.drawImage(background, 0, 0, null); // 背景图
        paintMainFighter(g); // 英雄机
        paintProjectiles(g); // 子弹
        paintFlyingEntitys(g); // 飞行物
        paintScore(g); // 分数
        paintState(g); // 状态
    }

    // 画英雄机
    public void paintMainFighter(Graphics g) {
        g.drawImage(MainFighter.getImage(), MainFighter.getX(), MainFighter.getY(), null);
    }

    // 画分数
    public void paintScore(Graphics g) {
        int x = 10;
        int y = 25;
        Font font = new Font(Font.SANS_SERIF, Font.BOLD, 22);
        g.setColor(new Color(0xFF0000));
        g.setFont(font);
        g.drawString("SCORE:" + score, x, y);
        y += 20;
        g.drawString("LIFE:" + MainFighter.getLife(), x, y);
    }
    public static void main(String[] args) {
        JFrame frame = new JFrame("Fly");
        SkyShooterGame game = new SkyShooterGame(); // 游戏画布

        frame.setLayout(null);  // 绝对布局
        game.setBounds(0, 0, WIDTH, HEIGHT); // 设置游戏面板大小
        frame.add(game); // 添加游戏面板

        // 添加按钮
        JButton startButton = new JButton("开始游戏");
        startButton.setBounds(40, HEIGHT + 10, 120, 30); // 在画面下方
        frame.add(startButton);

        JButton exitButton = new JButton("退出游戏");
        exitButton.setBounds(230, HEIGHT + 10, 120, 30);
        frame.add(exitButton);

        // 设置窗口大小：画布高度 + 按钮区域
        frame.setSize(WIDTH, HEIGHT + 80);
        frame.setAlwaysOnTop(true);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setIconImage(new ImageIcon("images/icon.jpg").getImage());
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);

        // 开始按钮功能（包括暂停恢复）
        startButton.addActionListener(e -> {
            if (game.state == START || game.state == PAUSE) {
                game.state = RUNNING;
                startButton.setVisible(false);
                exitButton.setVisible(false);

            }
        });

        //  退出按钮
        exitButton.addActionListener(e -> System.exit(0));

        game.action(); // 启动游戏逻辑
    }

    //启动执行代码
    public void action() {
        // 鼠标监听事件
        MouseAdapter l = new MouseAdapter() {
            @Override
            public void mouseMoved(MouseEvent e) { // 鼠标移动
                if (state == RUNNING) { // 运行状态下移动英雄机--随鼠标位置
                    int x = e.getX();
                    int y = e.getY();
                    MainFighter.moveTo(x, y);
                }
            }


            @Override
            public void mouseEntered(MouseEvent e) { // 鼠标进入
                if (state == PAUSE) { // 暂停状态下运行
                    state = RUNNING;
                }
            }
            @Override
            public void mouseClicked(MouseEvent e) {
                if (SwingUtilities.isLeftMouseButton(e)) {
                    if (state == START) {
                        state = RUNNING;
                    } else if (state == GAME_OVER) {
                        flyings = new FlyingEntity[0];
                        Projectiles = new Projectile[0];
                        MainFighter = new MainFighter();
                        score = 0;
                        state = START;
                    } else if (state == PAUSE) {
                        state = RUNNING; // ✅ 鼠标左键恢复游戏
                    }
                }
            }


            @Override
            public void mouseExited(MouseEvent e) { // 鼠标退出
                if (state == RUNNING) { // 游戏未结束，则设置其为暂停
                    state = PAUSE;
                }
            }
            @Override
            public void mousePressed(MouseEvent e) {
                if (SwingUtilities.isRightMouseButton(e)) {
                    if (state == RUNNING) {
                        state = PAUSE;
                    } else if (state == PAUSE) {
                        state = RUNNING;
                    }
                }
            }



        };
        this.addMouseMotionListener(l); // 处理鼠标滑动操作
        this.addMouseListener(l); // 处理鼠标点击操作


        timer = new Timer(); // 主流程控制
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                if (state == RUNNING) { // 运行状态
                    enterAction(); // 飞行物入场
                    stepAction(); // 走一步
                    shootAction(); // 英雄机射击
                    bangAction(); // 子弹打飞行物

                    outOfBoundsAction(); // 删除越界飞行物及子弹
                    checkGameOverAction(); // 检查游戏结束
                }
                repaint(); // 重绘，调用paint()方法
            }

        }, intervel, intervel);
    }

    int flyEnteredIndex = 0; // 飞行物入场计数
    int shootIndex = 0; // 射击计数

    public void bangAction() {
        for (int i = 0; i < Projectiles.length; i++) {
            Projectile b = Projectiles[i];
            bang(b);
        }
    }

    public void flyingStepAction() {
        for (int i = 0; i < flyings.length; i++) {
            FlyingEntity f = flyings[i];
            f.step();
        }
    }

    public boolean isGameOver() {
        for (int i = 0; i < flyings.length; i++) {
            int index = -1;
            FlyingEntity obj = flyings[i];
            if (MainFighter.hit(obj)) {
                MainFighter.subtractLife();
                MainFighter.setDoubleFire(0);
                index = i;
            }
            if (index != -1) {
                FlyingEntity t = flyings[index];
                flyings[index] = flyings[flyings.length - 1];
                flyings[flyings.length - 1] = t;
                flyings = Arrays.copyOf(flyings, flyings.length - 1);
            }
        }
        return MainFighter.getLife() <= 0;
    }

    public void checkGameOverAction() {
        if (isGameOver()) {
            state = GAME_OVER;
        }
    }

    public void shootAction() {
        shootIndex++;
        if (shootIndex % 30 == 0) {
            Projectile[] bs = MainFighter.shoot();
            Projectiles = Arrays.copyOf(Projectiles, Projectiles.length + bs.length);
            System.arraycopy(bs, 0, Projectiles, Projectiles.length - bs.length, bs.length);
        }
    }

    public void stepAction() {
        for (int i = 0; i < flyings.length; i++) {
            FlyingEntity f = flyings[i];
            f.step();
        }
        for (int i = 0; i < Projectiles.length; i++) {
            Projectile b = Projectiles[i];
            b.step();
        }
        MainFighter.step();
    }

    public void outOfBoundsAction() {
        int index = 0;
        FlyingEntity[] flyingLives = new FlyingEntity[flyings.length];
        for (int i = 0; i < flyings.length; i++) {
            FlyingEntity f = flyings[i];
            if (!f.outOfBounds()) {
                flyingLives[index++] = f;
            }
        }
        flyings = Arrays.copyOf(flyingLives, index);

        index = 0;
        Projectile[] ProjectileLives = new Projectile[Projectiles.length];
        for (int i = 0; i < Projectiles.length; i++) {
            Projectile b = Projectiles[i];
            if (!b.outOfBounds()) {
                ProjectileLives[index++] = b;
            }
        }
        Projectiles = Arrays.copyOf(ProjectileLives, index);
    }

    public void enterAction() {
        flyEnteredIndex++;
        if (flyEnteredIndex % 40 == 0) {
            FlyingEntity obj = nextOne();
            flyings = Arrays.copyOf(flyings, flyings.length + 1);
            flyings[flyings.length - 1] = obj;
        }
    }

    public void bang(Projectile Projectile) {
        int index = -1;
        for (int i = 0; i < flyings.length; i++) {
            FlyingEntity obj = flyings[i];
            if (obj.shootBy(Projectile)) {
                index = i;
                break;
            }
        }
        if (index != -1) {
            FlyingEntity one = flyings[index];
            FlyingEntity temp = flyings[index];
            flyings[index] = flyings[flyings.length - 1];
            flyings[flyings.length - 1] = temp;
            flyings = Arrays.copyOf(flyings, flyings.length - 1);

            if (one instanceof ScoreEnemy) {
                ScoreEnemy e = (ScoreEnemy) one;
                score += e.getScore();
            } else {
                RewardType a = (RewardType) one;
                int type = a.getType();
                switch (type) {
                    case RewardType.DOUBLE_FIRE:
                        MainFighter.addDoubleFire();
                        break;
                    case RewardType.LIFE:
                        MainFighter.addLife();
                        break;
                }
            }
        }
    }
    //随机生成飞行物
    public static FlyingEntity nextOne() {
        Random random = new Random();
        int type = random.nextInt(20); // [0,20)
        if (type < 3) {
            return new HoneyBee();
        } else {
            return new EnemyPlane();
        }
    }

}