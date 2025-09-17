package shiyan1;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class ScientificCalculator extends JFrame {
    private JTextField display;
    private String memoryText = "";
    private String currentInput = "0";

    private String currentOperator = "";
    private double firstOperand = 0;
    private boolean startNewInput = true;

    // 历史记录列表
    private ArrayList<String> history = new ArrayList<>();

    public ScientificCalculator() {
        setTitle("Scientific Calculator");
        setSize(500, 600);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        initUI();
    }

    private void initUI() {
        // 顶部面板：显示制作信息
        JPanel topPanel = new JPanel(new BorderLayout());
        JLabel makerLabel = new JLabel("Made by Huang Hongzhou", SwingConstants.CENTER);
        makerLabel.setFont(new Font("微软雅黑", Font.BOLD, 16));
        topPanel.add(makerLabel, BorderLayout.CENTER);
        add(topPanel, BorderLayout.NORTH);

        // 显示区：只有一个 JTextField，用于显示记忆和当前输入，光标始终闪烁
        display = new JTextField();
        display.setFont(new Font("Consolas", Font.BOLD, 24));
        display.setHorizontalAlignment(JTextField.RIGHT);
        display.setEditable(false);  // 不允许手动编辑，所有内容由程序控制
        display.setText(currentInput);
        add(display, BorderLayout.CENTER);

        // 按钮区：弄成5行5列
        String[] btnLabels = {
                "7", "8", "9", "/", "√",
                "4", "5", "6", "*", "n√",
                "1", "2", "3", "-", "x²",
                "0", ".", "%", "+", "x³",
                "^", "=", "C", "Hist", "Exit"
        };

        JPanel buttonPanel = new JPanel(new GridLayout(5, 5, 5, 5));
        for (String label : btnLabels) {
            JButton btn = new JButton(label);
            btn.setFont(new Font("Consolas", Font.BOLD, 18));
            btn.addActionListener(new ButtonHandler());
            buttonPanel.add(btn);
        }
        add(buttonPanel, BorderLayout.SOUTH);
    }

    // 更新显示区：将记忆部分和当前输入部分拼接，并将光标置于文本末尾
    private void updateDisplay() {
        display.setText(memoryText + currentInput);
    }

    // 按钮事件处理
    private class ButtonHandler implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String cmd = e.getActionCommand();
            // 数字或小数点输入
            if (cmd.matches("[0-9\\.]")) {
                if (startNewInput) {
                    currentInput = cmd.equals(".") ? "0." : cmd;
                    startNewInput = false;
                } else {
                    // 防止重复小数点
                    if (cmd.equals(".") && currentInput.contains(".")) {
                        return;
                    }
                    currentInput += cmd;
                }
                updateDisplay();
            }
            else if (cmd.equals("C")) {
                // 清除全部
                memoryText = "";
                currentInput = "0";
                currentOperator = "";
                startNewInput = true;
                updateDisplay();
            }
            else if (cmd.equals("Exit")) {
                System.exit(0);
            }
            else if (cmd.equals("Hist")) {
                // 显示历史记录
                if (history.isEmpty()) {
                    JOptionPane.showMessageDialog(null, "No history!");
                } else {
                    StringBuilder histText = new StringBuilder();
                    for (String record : history) {
                        histText.append(record).append("\n");
                    }
                    JTextArea textArea = new JTextArea(histText.toString());
                    textArea.setEditable(false);
                    JScrollPane scrollPane = new JScrollPane(textArea);
                    scrollPane.setPreferredSize(new Dimension(400, 300));
                    JOptionPane.showMessageDialog(null, scrollPane, "History", JOptionPane.INFORMATION_MESSAGE);
                }
            }
            else if (cmd.equals("=")) {
                // 二元运算：取当前输入作为第二操作数，计算结果
                try {
                    double secondOperand = Double.parseDouble(currentInput);
                    double result = compute(firstOperand, secondOperand, currentOperator);
                    String expression = memoryText + currentInput + " = " + formatResult(result);
                    history.add(expression);
                    // 计算完成后，清空记忆部分，当前输入置为结果
                    currentInput = formatResult(result);
                    memoryText = "";
                    currentOperator = "";
                    startNewInput = true;
                    updateDisplay();
                } catch (Exception ex) {
                    currentInput = "Error";
                    memoryText = "";
                    currentOperator = "";
                    startNewInput = true;
                    updateDisplay();
                }
            }
            // 运算符：+ - * / ^ 以及百分号（%）
            else if (cmd.equals("+") || cmd.equals("-") || cmd.equals("*") || cmd.equals("/") || cmd.equals("^") || cmd.equals("%")) {
                try {
                    firstOperand = Double.parseDouble(currentInput);
                } catch (Exception ex) {
                    currentInput = "Error";
                    updateDisplay();
                    return;
                }
                currentOperator = cmd;
                // 将运算前的数和运算符保存在记忆部分，当前输入清空
                memoryText = currentInput + " " + cmd + " ";
                startNewInput = true;
                currentInput = "";
                updateDisplay();
            }
            // 单目运算：平方、立方、开方、n次根（n√）
            else if (cmd.equals("x²")) {
                try {
                    double num = Double.parseDouble(currentInput);
                    double result = num * num;
                    String exp = "sqr(" + num + ") = " + formatResult(result);
                    history.add(exp);
                    currentInput = formatResult(result);
                    memoryText = "";
                    startNewInput = true;
                    updateDisplay();
                } catch (Exception ex) {
                    currentInput = "Error";
                    startNewInput = true;
                    updateDisplay();
                }
            }
            else if (cmd.equals("x³")) {
                try {
                    double num = Double.parseDouble(currentInput);
                    double result = num * num * num;
                    String exp = "cube(" + num + ") = " + formatResult(result);
                    history.add(exp);
                    currentInput = formatResult(result);
                    memoryText = "";
                    startNewInput = true;
                    updateDisplay();
                } catch (Exception ex) {
                    currentInput = "Error";
                    startNewInput = true;
                    updateDisplay();
                }
            }
            else if (cmd.equals("√")) {
                try {
                    double num = Double.parseDouble(currentInput);
                    if (num < 0) throw new ArithmeticException();
                    double result = Math.sqrt(num);
                    String exp = "sqrt(" + num + ") = " + formatResult(result);
                    history.add(exp);
                    currentInput = formatResult(result);
                    memoryText = "";
                    startNewInput = true;
                    updateDisplay();
                } catch (Exception ex) {
                    currentInput = "Error";
                    startNewInput = true;
                    updateDisplay();
                }
            }
            else if (cmd.equals("n√")) { // n次根：输入根指数n，然后计算 num^(1/n)
                try {
                    double num = Double.parseDouble(currentInput);
                    String input = JOptionPane.showInputDialog("Enter root index n:");
                    if (input == null || input.trim().isEmpty()) return;
                    double n = Double.parseDouble(input);
                    if (n == 0) throw new ArithmeticException();
                    if (n % 2 == 0 && num < 0) throw new ArithmeticException();
                    double result = Math.pow(num, 1.0 / n);
                    String exp = "root" + n + "(" + num + ") = " + formatResult(result);
                    history.add(exp);
                    currentInput = formatResult(result);
                    memoryText = "";
                    startNewInput = true;
                    updateDisplay();
                } catch (Exception ex) {
                    currentInput = "Error";
                    startNewInput = true;
                    updateDisplay();
                }
            }
        }
    }

    // 根据操作符计算二元运算结果
    private double compute(double a, double b, String op) throws Exception {
        switch (op) {
            case "+":
                return a + b;
            case "-":
                return a - b;
            case "*":
                return a * b;
            case "/":
                if (b == 0) throw new ArithmeticException();
                return a / b;
            case "^":
                return Math.pow(a, b);
            case "%":
                // 百分比运算：a % b 视为 a * b/100
                return a * b / 100;
            default:
                throw new Exception("Unknown operator");
        }
    }

    // 格式化数字，保留最多8位有效小数；当数字过大或过小时使用科学计数法
    private String formatResult(double num) {
        DecimalFormat df = new DecimalFormat("0.########");
        df.setRoundingMode(RoundingMode.HALF_UP);
        // 如果绝对值过大或过小，则采用科学计数法
        if (num != 0 && (Math.abs(num) >= 1e8 || Math.abs(num) < 1e-4)) {
            df = new DecimalFormat("0.########E0");
            df.setRoundingMode(RoundingMode.HALF_UP);
        }
        return df.format(num);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new ScientificCalculator().setVisible(true);
        });
    }
}
