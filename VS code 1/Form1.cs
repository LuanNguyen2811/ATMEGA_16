using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO.Ports;
using System.Diagnostics.Eventing.Reader;
using ZedGraph;

namespace VS_code_1
{
    public partial class form1 : Form
    {
        public form1()
        {
            InitializeComponent();
        }
        string[] pause = { "1200", "2400", "4800", "9600", "19200", "38400", "57600", "14880" };
        string[] Dled = { "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4","4.5","5" };
        private void Form1_Load(object sender, EventArgs e)
        {
            String[] listnamecom = SerialPort.GetPortNames();
            congcom.Items.AddRange(listnamecom);
            congbaud.Items.AddRange(pause);
            comboBox1.Items.AddRange(Dled);

            GraphPane mypanne = zedGraphControl1.GraphPane;
            mypanne.Title.Text = "Biểu đồ nhiệt độ";
            mypanne.YAxis.Title.Text = "Nhiệt độ";
            mypanne.XAxis.Title.Text = "Thời gian";

            RollingPointPairList list1 = new RollingPointPairList(60000);

            LineItem duongline = mypanne.AddCurve("Nhiệt dộ", list1, Color.Red, SymbolType.Diamond);
            mypanne.XAxis.Scale.Min = 0;
            mypanne.XAxis.Scale.Max = 100;
            mypanne.XAxis.Scale.MinorStep = 1;
            mypanne.XAxis.Scale.MajorStep = 5;

            mypanne.YAxis.Scale.Min = 0;
            mypanne.YAxis.Scale.Max = 100;
            mypanne.YAxis.Scale.MinorStep = 1;
            mypanne.YAxis.Scale.MajorStep = 5;
            zedGraphControl1.AxisChange();
        }
        int tong = 0;
        public void draw (double line1)
        {
            LineItem duongline = zedGraphControl1.GraphPane.CurveList[0]as LineItem;
            if(duongline == null )
            {
                return;
            }
            IPointListEdit list = duongline.Points as IPointListEdit;
            if (list == null)
            {
                return;
            }
            list.Add(tong, line1);
            zedGraphControl1.AxisChange();
            zedGraphControl1.Invalidate();
            tong += 2;
        }        
        private void button1_Click(object sender, EventArgs e)
        {
            if (congcom.Text == "")
            {
                MessageBox.Show("Bạn chưa chọn cổng COM", "Thông Báo");
            }
            else if (congbaud.Text == "")
            {
                MessageBox.Show("Bạn chưa chọn tốc độ baudrate", "Thông Báo");
            }
            if (serialPort1.IsOpen == true)
            {
                serialPort1.Close();
                button1.Text = "Connect";
            }
            else if (serialPort1.IsOpen == false)
            {
                serialPort1.PortName = congcom.Text;
                serialPort1.BaudRate = int.Parse(congbaud.Text);
                serialPort1.Open();
                button1.Text = "Off";
            }
        }
        bool tb1 = true;

        private void button2_Click(object sender, EventArgs e)
            {
                try
                {
                    if (tb1 == true)
                    {
                        serialPort1.Write("1");
                        button2.Text = "OFF";
                        pictureBox1.Image = global::VS_code_1.Properties.Resources.densang;
                        tb1 = false;
                    }
                    else
                    {
                        serialPort1.Write("q");
                        button2.Text = "ON";
                        pictureBox1.Image = global::VS_code_1.Properties.Resources.dentat;
                        tb1 = true;
                    }
                }
                catch
                {
                    MessageBox.Show("Lỗi");
                }
        }
        bool tb2 = true;
        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb2 == true)
                {
                    serialPort1.Write("2");
                    button3.Text = "OFF";
                    pictureBox2.Image = global::VS_code_1.Properties.Resources.densang;
                    tb2 = false;
                }
                else
                {
                    serialPort1.Write("w");
                    button3.Text = "ON";
                    pictureBox2.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb2 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }
        bool tb3 = true;
        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb3 == true)
                {
                    serialPort1.Write("3");
                    button4.Text = "OFF";
                    pictureBox3.Image = global::VS_code_1.Properties.Resources.densang;
                    tb3 = false;
                }
                else
                {
                    serialPort1.Write("e");
                    button4.Text = "ON";
                    pictureBox3.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb3 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }
        bool tb4 = true;
        private void button10_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb4 == true)
                {
                    serialPort1.Write("4");
                    button10.Text = "OFF";
                    pictureBox4.Image = global::VS_code_1.Properties.Resources.densang;
                    tb4 = false;
                }
                else
                {
                    serialPort1.Write("r");
                    button10.Text = "ON";
                    pictureBox4.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb4 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }
        bool tb5 = true;
        private void button7_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb5 == true)
                {
                    serialPort1.Write("5");
                    button7.Text = "OFF";
                    pictureBox8.Image = global::VS_code_1.Properties.Resources.densang;
                    tb5 = false;
                }
                else
                {
                    serialPort1.Write("t");
                    button7.Text = "ON";
                    pictureBox8.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb5 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }
        bool tb6 = true;
        private void button8_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb6 == true)
                {
                    serialPort1.Write("6");
                    button8.Text = "OFF";
                    pictureBox7.Image = global::VS_code_1.Properties.Resources.densang;
                    tb6 = false;
                }
                else
                {
                    serialPort1.Write("y");
                    button8.Text = "ON";
                    pictureBox7.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb6 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }
        bool tb7 = true;
        private void button6_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb7 == true)
                {
                    serialPort1.Write("7");
                    button6.Text = "OFF";
                    pictureBox6.Image = global::VS_code_1.Properties.Resources.densang;
                    tb7 = false;
                }
                else
                {
                    serialPort1.Write("u");
                    button6.Text = "ON";
                    pictureBox6.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb7 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }
        bool tb8 = true;
        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                if (tb8 == true)
                {
                    serialPort1.Write("8");
                    button5.Text = "OFF";
                    pictureBox5.Image = global::VS_code_1.Properties.Resources.densang;
                    tb8 = false;
                }
                else
                {
                    serialPort1.Write("i");
                    button5.Text = "ON";
                    pictureBox5.Image = global::VS_code_1.Properties.Resources.dentat;
                    tb8 = true;
                }
            }
            catch
            {
                MessageBox.Show("Lỗi");
            }
        }

        private bool isPortOpen = false;

        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string data = "";
            data = serialPort1.ReadLine();
            data = data.Trim();
            if (data.Length > 0)
            {
                if (int.TryParse(data, out int result))
                    {
                    Invoke(new MethodInvoker(() => listBox1.Items.Add(data)));
                    Invoke(new MethodInvoker(() => draw(Convert.ToDouble(data))));
                    }
                else
                {
                    string t1 = data.Substring(0,3);
                    Invoke(new MethodInvoker(() => listBox2.Items.Add(t1)));
                }
            }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            serialPort1.Write("c");
            if (comboBox1.Text == "0.5")
            {
                serialPort1.Write("a");

            }
            if (comboBox1.Text == "1")
            {
                serialPort1.Write("s");

            }
            if (comboBox1.Text == "1.5")
            {
                serialPort1.Write("d");

            }
            if (comboBox1.Text == "2")
            {
                serialPort1.Write("f");

            }
            if (comboBox1.Text == "2.5")
            {
                serialPort1.Write("g");

            }
            if (comboBox1.Text == "3")
            {
                serialPort1.Write("h");

            }
            if (comboBox1.Text == "3.5")
            {
                serialPort1.Write("j");

            }
            if (comboBox1.Text == "4")
            {
                serialPort1.Write("k");

            }
            if (comboBox1.Text == "4.5")
            {
                serialPort1.Write("l");

            }
            if (comboBox1.Text == "5")
            {
                serialPort1.Write("z");

            }
        }

        private void button11_Click(object sender, EventArgs e)
        {
            serialPort1.Write("x");
        }
    }
}

