public class AdoptionDashboards{
   
    public List<PieWedgeData> getPieData() {
        List<PieWedgeData> data = new List<PieWedgeData>();
        data.add(new PieWedgeData('Jan', 30,40,55));
        data.add(new PieWedgeData('Feb', 15,35,40));
        data.add(new PieWedgeData('Mar', 10,50,40));
        data.add(new PieWedgeData('Apr', 20,25,30));
        data.add(new PieWedgeData('May', 20,30,35));
        data.add(new PieWedgeData('Jun', 5,10,15));
        return data;
    }

    // Wrapper class
    public class PieWedgeData {

        public String name { get; set; }
        public Integer data1 { get; set; }
        public Integer data2 { get; set; }
        public Integer data3 { get; set; }
        public PieWedgeData(String name, Integer data1,Integer data2,Integer data3) {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2;
            this.data3 = data3;
        }
    }
}