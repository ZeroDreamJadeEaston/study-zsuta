// 奖励类型接口，用于标记具有奖励功能的飞行实体
public interface RewardType {
    // 奖励常量：双倍火力
    int DOUBLE_FIRE = 0;

    // 奖励常量：加一条命
    int LIFE = 1;

    // 返回当前奖励类型（0 表示双倍火力，1 表示加命）
    int getType();
}
