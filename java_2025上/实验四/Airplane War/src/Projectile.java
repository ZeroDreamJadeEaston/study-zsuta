// Projectile 类：表示子弹，是一种飞行实体

public class Projectile extends FlyingEntity {
    private int speed = 3; // 子弹移动速度

    // 构造方法：设置初始坐标和图像
    public Projectile(int x, int y) {
        this.x = x;
        this.y = y;
        this.image = SkyShooterGame.Projectile;
    }

    // 判断子弹是否飞出屏幕上边界
    @Override
    public boolean outOfBounds() {
        return y < -height;
    }

    // 每一帧子弹向上移动
    @Override
    public void step() {
        y -= speed;
    }
}
