import java.util.Random;

// 精英敌人蜜蜂（带奖励类型）
public class HoneyBee extends FlyingEntity implements RewardType {
    private int ySpeed = 2;         // y方向速度
    private int RewardTypeType;     // 奖励类型
    private int xSpeed = 1;         // x方向速度

    // 构造方法，初始化精英敌人蜜蜂位置、图片等信息
    public HoneyBee() {
        this.image = SkyShooterGame.HoneyBee;
        width = image.getWidth();
        height = image.getHeight();
        y = -height;
        Random rand = new Random();
        x = rand.nextInt(SkyShooterGame.WIDTH - width);
        RewardTypeType = rand.nextInt(2); // 随机奖励类型
    }

    // 获取奖励类型（0 表示双倍火力，1 表示加命）
    public int getType() {
        return RewardTypeType;
    }

    // 判断是否超出屏幕底部
    @Override
    public boolean outOfBounds() {
        return y > SkyShooterGame.HEIGHT;
    }

    // 飞行更新位置，左右反弹式移动
    @Override
    public void step() {
        x += xSpeed;
        y += ySpeed;
        if (x > SkyShooterGame.WIDTH - width) {
            xSpeed = -1;
        }
        if (x < 0) {
            xSpeed = 1;
        }
    }
}
