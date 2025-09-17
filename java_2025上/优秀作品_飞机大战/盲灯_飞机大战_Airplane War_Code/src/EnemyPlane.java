import java.util.Random;

// 敌人飞机：是飞行实体，也是计分敌人
public class EnemyPlane extends FlyingEntity implements ScoreEnemy {

    // 构造函数：初始化数据
    public EnemyPlane() {
        this.image = SkyShooterGame.enemyPlane;
        width = image.getWidth();
        height = image.getHeight();
        y = -height;
        Random rand = new Random();
        x = rand.nextInt(SkyShooterGame.WIDTH - width);
    }

    // 飞行速度
    private int speed = 3;

    // 获取得分
    @Override
    public int getScore() {
        return 5;
    }

    // 判断是否出界
    @Override
    public boolean outOfBounds() {
        return y > SkyShooterGame.HEIGHT;
    }

    // 飞行移动
    @Override
    public void step() {
        y += speed;
    }
}
