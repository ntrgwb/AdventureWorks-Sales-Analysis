# AdventureWorks - Phân tích Doanh thu & Lợi nhuận

## Mục lục

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Mục tiêu phân tích](#2-mục-tiêu-phân-tích)
3. [Dữ liệu](#3-dữ-liệu)
4. [Công cụ sử dụng](#4-công-cụ-sử-dụng)
5. [Tiền xử lý dữ liệu bằng SQL](#5-tiền-xử-lý-dữ-liệu-bằng-sql)
6. [Mô hình dữ liệu](#6-mô-hình-dữ-liệu)
7. [Các DAX Measures](#7-các-dax-measures)
8. [Dashboard](#8-dashboard)
9. [Insight chính](#9-insight-chính)
10. [Đề xuất kinh doanh](#10-đề-xuất-kinh-doanh)

---

## 1. Tổng quan dự án

Dự án sử dụng bộ dữ liệu **AdventureWorksDW2019** để phân tích hoạt động bán hàng của AdventureWorks trên các khía cạnh:

- Doanh thu và lợi nhuận
- Hiệu quả sản phẩm
- Hiệu quả theo khu vực
- Phân khúc khách hàng

Mục tiêu của dự án là xây dựng một quy trình Business Intelligence hoàn chỉnh, từ dữ liệu thô trong SQL Server đến dashboard Power BI phục vụ việc theo dõi và hỗ trợ ra quyết định kinh doanh.

Quy trình thực hiện:

**SQL Server → Data Preparation → Data Modeling → DAX → Power BI Dashboard → Business Insights**

---

## 2. Mục tiêu phân tích

Dự án tập trung trả lời 4 nhóm câu hỏi kinh doanh chính.

### 2.1. Tổng quan hoạt động kinh doanh

- Tổng doanh thu và lợi nhuận của doanh nghiệp là bao nhiêu?
- Biên lợi nhuận hiện tại như thế nào?
- Doanh thu thay đổi như thế nào theo thời gian?
- Những sản phẩm nào đóng góp nhiều lợi nhuận nhất?

### 2.2. Phân tích sản phẩm

- Category và Subcategory nào tạo ra nhiều doanh thu nhất?
- Nhóm sản phẩm nào có Profit Margin cao?
- Sản phẩm nào tạo ra nhiều Revenue và Profit nhất?

### 2.3. Phân tích khu vực

- Quốc gia nào đóng góp nhiều Revenue và Profit nhất?
- Profit Margin khác nhau như thế nào giữa các quốc gia?
- Revenue được phân bổ như thế nào giữa các Territory Group?
- Hiệu quả kinh doanh của các khu vực thay đổi như thế nào theo thời gian?

### 2.4. Phân tích khách hàng

- Nhóm tuổi nào tạo ra nhiều Revenue nhất?
- Nhóm thu nhập nào đóng góp nhiều Revenue nhất?
- Nhóm tuổi nào có số lượng khách hàng lớn nhất?
- Sự kết hợp giữa Age Group và Income Tier ảnh hưởng như thế nào đến Revenue?
- Những khách hàng nào tạo ra Revenue cao nhất?

---

## 3. Dữ liệu

Dự án sử dụng cơ sở dữ liệu:

**AdventureWorksDW2019**

Bảng giao dịch chính:

`FactInternetSales`

gồm:

**60,398 dòng dữ liệu bán hàng**

và:

**27,659 đơn hàng khác nhau.**

### Các bảng nguồn chính

| Bảng | Vai trò |
|---|---|
| `FactInternetSales` | Dữ liệu giao dịch bán hàng |
| `DimCustomer` | Thông tin khách hàng |
| `DimProduct` | Thông tin sản phẩm |
| `DimProductSubcategory` | Phân nhóm sản phẩm |
| `DimProductCategory` | Category sản phẩm |
| `DimSalesTerritory` | Khu vực bán hàng |
| `DimDate` | Thông tin thời gian |
| `DimGeography` | Thông tin địa lý khách hàng |

Sau quá trình xử lý, dữ liệu được tổ chức lại thành mô hình đơn giản hơn phục vụ phân tích trong Power BI.

---

## 4. Công cụ sử dụng

| Công cụ | Mục đích |
|---|---|
| SQL Server | Truy vấn dữ liệu |
| SQL | Làm sạch, JOIN và biến đổi dữ liệu |
| Power Query | Load dữ liệu và kiểm tra Data Type |
| DAX | Xây dựng KPI và Business Metrics |
| Power BI Desktop | Data Modeling và Visualization |
---

## 5. Tiền xử lý dữ liệu bằng SQL

SQL được sử dụng để chuyển dữ liệu từ AdventureWorksDW2019 thành các bảng phù hợp cho việc phân tích.

File SQL:

`Sql/data_preparation.sql`

### 5.1. Fact Internet Sales

Bảng Fact giữ các trường quan trọng:

- SalesOrderNumber
- SalesOrderLineNumber
- OrderDateKey
- CustomerKey
- ProductKey
- SalesTerritoryKey
- OrderQuantity
- UnitPrice
- TotalProductCost
- SalesAmount
---

### 5.2. Customer Dimension

`DimCustomer` được kết hợp với `DimGeography` để bổ sung thông tin khách hàng.

Các thuộc tính:

- Customer Full Name
- Gender
- Birth Date
- Age
- Age Group
- Yearly Income
- Income Tier
- Occupation
- City
- Country

Age Group được chia thành:

- Under 30
- 30-39
- 40-49
- 50-59
- 60+

Income Tier được chia thành:

- Low Income
- Middle Income
- High Income

---

### 5.3. Product Dimension

Thông tin sản phẩm được kết hợp từ:

`DimProduct`

→ `DimProductSubcategory`

→ `DimProductCategory`

Qua đó mỗi sản phẩm có thể được phân tích theo:

**Product → Subcategory → Category**

Các giá trị NULL ở một số thuộc tính phân loại được thay bằng `Unknown` và `Other`.

---

### 5.4. Date Dimension

`DimDate` cung cấp các thuộc tính thời gian:

- Date
- Day
- Day Name
- Month
- Month Number
- Quarter
- Year
- Year-Month

Bảng Date được sử dụng để thực hiện các phân tích Time Intelligence trong Power BI.

---

### 5.5. Territory Dimension

`DimSalesTerritory` cung cấp:

- Region
- Country
- Territory Group

Cho phép phân tích hiệu quả kinh doanh theo nhiều cấp địa lý.

---

## 6. Mô hình dữ liệu

Dữ liệu được tổ chức theo **Star Schema**.

![Data Model](Images/data_model.png)

`Fact_InternetSales` là bảng Fact trung tâm.

Các Dimension kết nối với Fact thông qua:

- `CustomerKey`
- `ProductKey`
- `OrderDateKey`
- `SalesTerritoryKey`

và:

## 7. Các DAX Measures

Project xây dựng nhiều DAX Measure phục vụ phân tích.

### KPI chính

```text
Revenue
Total Cost
Total Profit
Profit Margin %
Total Orders
Units Sold
Total Customers
AOV
Average Selling Price
Revenue per Customer
```

### Time Intelligence

```text
Sales LY
Profit LY
YoY Sales Growth %
YoY Profit Growth %
Revenue YTD
Profit YTD
```

### Product Analysis

```text
Revenue Share %
Product Profit Rank
Top 5 Product Flag
```

## 8. Dashboard

Dashboard gồm **4 trang phân tích chính**.

### 8.1. Executive Overview

Trang tổng quan giúp theo dõi nhanh:

- Revenue
- Profit
- Profit Margin
- Orders
- AOV
- Sales Trend
- Revenue Contribution by Category
- Top 5 Most Profitable Products

![Data Model](Images/Executive_Overview.png)

---

### 8.2. Product & Category Analysis

Trang này tập trung phân tích hiệu quả sản phẩm thông qua:

- Revenue & Profit by Category
- Profit Margin by Category
- Revenue & Profit by Subcategory
- Top 10 Products by Revenue
- Product Performance: Revenue vs Profit Margin

![Product & Category Analysis](Images/Product_Category.png)

---

### 8.3. Regional Sales Analysis

Trang Regional Sales phân tích hiệu quả kinh doanh theo địa lý:

- Revenue & Profit by Country
- Profit Margin by Country
- Revenue Share by Territory Group
- Revenue by Region
- Revenue Trend by Territory Group
- Regional Performance Detail

![Regional Sales Analysis](Images/Regional_Sales.png)

---

### 8.4. Customer Segmentation

Trang Customer Segmentation tập trung vào hành vi và giá trị của các nhóm khách hàng:

- Revenue by Age Group
- Revenue by Income Tier
- Customers by Age Group
- Revenue by Age Group & Income Tier
- Top 10 Customers by Revenue

![Customer Segmentation](Images/Customer_Segmentation.png)

---

## 9. Insight chính

### 9.1. Bikes là nguồn doanh thu chính

Bikes tạo ra khoảng:

**$28.32M Revenue**

tương đương khoảng:

**96.46% tổng Revenue**

Điều này cho thấy doanh thu của AdventureWorks phụ thuộc rất lớn vào nhóm Bikes.

---

### 9.2. Accessories có Profit Margin cao

Mặc dù Accessories chỉ đóng góp khoảng:

**2.39% tổng Revenue**

nhưng nhóm này đạt:

**~62.60% Profit Margin**

cao hơn đáng kể so với Bikes (~40.63%).

Điều này cho thấy Accessories có giá trị về mặt profit dù doanh thu thấp.

---

### 9.3. Road Bikes là Subcategory tạo Revenue lớn nhất

Trong các Subcategory:

- Road Bikes: ~$14.5M Revenue
- Mountain Bikes: ~$10.0M Revenue
- Touring Bikes: ~$3.8M Revenue

Road Bikes là nhóm sản phẩm đóng góp doanh thu lớn nhất.

---

### 9.4. North America dẫn đầu về Revenue

Theo Territory Group:

- North America: ~$11.37M
- Pacific: ~$9.06M
- Europe: ~$8.93M

North America là thị trường đóng góp Revenue lớn nhất.

---

### 9.5. Nhóm khách hàng 30-39 tuổi đóng góp Revenue lớn nhất

Nhóm tuổi **30-39** tạo ra khoảng:

**$10.4M Revenue**

và cũng là nhóm có số lượng khách hàng lớn nhất, khoảng:

**6.4K customers**

Điều này cho thấy nhóm 30-39 là một phân khúc khách hàng quan trọng đối với AdventureWorks.

---

### 9.6. Middle Income là nhóm thu nhập đóng góp Revenue lớn nhất

Revenue theo Income Tier:

- Middle Income: ~$13.7M
- High Income: ~$9.3M
- Low Income: ~$6.3M

Middle Income hiện là nhóm đóng góp Revenue lớn nhất.

---

### 9.7. 30-39 + Middle Income là một phân khúc nổi bật

Khi kết hợp Age Group và Income Tier, nhóm:

**30-39 + Middle Income**

tạo ra khoảng:

**$4.79M Revenue**

Đây là một trong những customer segment nổi bật nhất trong dữ liệu.

---

## 10. Đề xuất kinh doanh

### Cross-selling Accessories với Bikes

Bikes tạo ra phần lớn Revenue trong khi Accessories có Profit Margin cao.

Do đó doanh nghiệp có thể tăng lợi nhuận trên mỗi giao dịch bằng cách bán kèm các sản phẩm Accessories khi khách hàng mua Bikes.

Ví dụ:

**Bike + Bottles and Cages**

---

### Xây dựng Bundle sản phẩm

Có thể thử nghiệm các bundle như:

- Bike + Hydration Pack
- Bike + Bottle and Cages
  
Mục tiêu là tăng:

- Revenue per Customer
- Profit per Order

---

### Tập trung vào nhóm khách hàng 30-39

Nhóm 30-39 vừa có lượng khách hàng lớn vừa tạo ra Revenue cao.

Doanh nghiệp có thể ưu tiên:

- Personalized offers
- Product recommendations
- Customer retention campaigns

cho nhóm khách hàng này.

---

### Tối ưu chiến lược theo khu vực

North America đang dẫn đầu về Revenue.

Tuy nhiên doanh nghiệp không nên chỉ đánh giá thị trường dựa trên Revenue mà cần kết hợp:

**Revenue + Profit + Customer Volume**

để xác định khu vực thực sự mang lại hiệu quả kinh doanh tốt nhất.

---

## Kết luận

Dự án xây dựng một quy trình BI hoàn chỉnh từ việc truy vấn và xử lý dữ liệu bằng SQL, thiết kế Star Schema, xây dựng DAX Measure đến trực quan hóa dữ liệu bằng Power BI.

Dashboard cho phép phân tích hoạt động kinh doanh từ nhiều góc nhìn khác nhau, bao gồm:

**Executive Performance → Product → Region → Customer**

Qua đó, dự án không chỉ tập trung vào việc trực quan hóa dữ liệu mà còn sử dụng dữ liệu để xác định các cơ hội cải thiện doanh thu và lợi nhuận.
