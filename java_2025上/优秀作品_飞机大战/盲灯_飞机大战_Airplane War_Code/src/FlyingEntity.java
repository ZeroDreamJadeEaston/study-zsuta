import java.awt.image.BufferedImage;

public abstract class FlyingEntity {
    protected BufferedImage image;  // 图片
    protected int height;           // 高度
    protected int x;                // 横坐标
    protected int y;                // 纵坐标
    protected int width;            // 宽度

    // 获取图像
    public BufferedImage getImage() {
        return image;
    }

    // 设置图像
    public void setImage(BufferedImage image) {
        this.image = image;
    }

    // 设置高度
    public void setHeight(int height) {
        this.height = height;
    }

    // 获取高度
    public int getHeight() {
        return height;
    }

    // 设置横坐标
    public void setX(int x) {
        this.x = x;
    }

    // 获取横坐标
    public int getX() {
        return x;
    }

    // 设置纵坐标
    public void setY(int y) {
        this.y = y;
    }

    // 获取纵坐标
    public int getY() {
        return y;
    }

    // 设置宽度
    public void setWidth(int width) {
        this.width = width;
    }

    // 获取宽度
    public int getWidth() {
        return width;
    }

    // 判断当前飞行物是否被某颗子弹击中
    public boolean shootBy(Projectile p) {
        int x = p.x;
        int y = p.y;
        return this.x < x && x < this.x + width &&
                this.y < y && y < this.y + height;
    }

    // 抽象方法：判断是否越界
    public abstract boolean outOfBounds();

    // 抽象方法：移动一步
    public abstract void step();
}
