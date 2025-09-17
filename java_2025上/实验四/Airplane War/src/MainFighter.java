import java.awt.image.BufferedImage;

// 英雄机：玩家控制的主要飞行物
public class MainFighter extends FlyingEntity {

    private int index = 0;                  // 图片切换用的索引
    private BufferedImage[] images = {};    // 英雄机图片序列
    private int doubleFire;                // 当前双倍火力状态
    private int life;                      // 英雄命数

    // 构造函数，初始化英雄机的初始位置、生命、图片等信息
    public MainFighter() {
        life = 3;
        doubleFire = 0;
        images = new BufferedImage[]{SkyShooterGame.MainFighter0, SkyShooterGame.MainFighter1};
        image = SkyShooterGame.MainFighter0;
        width = image.getWidth();
        height = image.getHeight();
        x = 150;
        y = 400;
    }

    // 获取双倍火力状态数值
    public int isDoubleFire() {
        return doubleFire;
    }

    // 设置当前双倍火力数值
    public void setDoubleFire(int doubleFire) {
        this.doubleFire = doubleFire;
    }

    // 增加双倍火力（设为固定40帧）
    public void addDoubleFire() {
        doubleFire = 40;
    }

    // 英雄增加一条命
    public void addLife() {
        life++;
    }

    // 英雄减少一条命
    public void subtractLife() {
        life--;
    }

    // 获取当前命数
    public int getLife() {
        return life;
    }

    // 英雄跟随鼠标移动到目标位置（居中）
    public void moveTo(int x, int y) {
        this.x = x - width / 2;
        this.y = y - height / 2;
    }

    // 判断英雄机是否越界，永远返回false
    @Override
    public boolean outOfBounds() {
        return false;
    }

    // 发射子弹：根据火力模式决定发射数量
    public Projectile[] shoot() {
        int xStep = width / 4;
        int yStep = 20;
        if (doubleFire > 0) {
            Projectile[] Projectiles = new Projectile[2];
            Projectiles[0] = new Projectile(x + xStep, y - yStep);
            Projectiles[1] = new Projectile(x + 3 * xStep, y - yStep);
            return Projectiles;
        } else {
            Projectile[] Projectiles = new Projectile[1];
            Projectiles[0] = new Projectile(x + 2 * xStep, y - yStep);
            return Projectiles;
        }
    }

    // 每一帧图像切换，构成英雄机动画效果
    @Override
    public void step() {
        if (images.length > 0) {
            image = images[index++ / 10 % images.length];
        }
    }

    // 碰撞检测函数，判断当前英雄机是否与其他飞行物体发生碰撞
    public boolean hit(FlyingEntity other) {
        int x1 = other.x - this.width / 2;
        int x2 = other.x + this.width / 2 + other.width;
        int y1 = other.y - this.height / 2;
        int y2 = other.y + this.height / 2 + other.height;
        int MainFighterx = this.x + this.width / 2;
        int MainFightery = this.y + this.height / 2;
        return MainFighterx > x1 && MainFighterx < x2 && MainFightery > y1 && MainFightery < y2;
    }
}
