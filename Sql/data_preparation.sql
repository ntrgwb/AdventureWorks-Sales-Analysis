--Fact_InternetSales
select
    SalesOrderNumber,
    SalesOrderLineNumber,
    OrderDateKey,
    CustomerKey,
    ProductKey,
    SalesTerritoryKey,
    OrderQuantity,
    UnitPrice,
    TotalProductCost,
    SalesAmount
from dbo.FactInternetSales;

--Dim_Customer
select
    c.CustomerKey,
    concat(
        c.FirstName,
        ' ',
        case
            when c.MiddleName is not null
                then c.MiddleName + ' '
            else ''
        end,
        c.LastName
    ) as CustomerFullName,
    c.Gender,
    case
        when c.Gender = 'M' then 'Male'
        when c.Gender = 'F' then 'Female'
        else 'Unknown'
    end as GenderFull,

    c.BirthDate,

    datediff(year, c.BirthDate, '2014-01-28')
    -
    case
        when dateadd(
            year,
            datediff(year, c.BirthDate, '2014-01-28'),
            c.BirthDate
        ) > '2014-01-28'
        then 1
        else 0
    end as Age,
    case
        when datediff(year, c.BirthDate, '2014-01-28') < 30
            then 'Under 30'
        when datediff(year, c.BirthDate, '2014-01-28') < 40
            then '30-39'
        when datediff(year, c.BirthDate, '2014-01-28') < 50
            then '40-49'
        when datediff(year, c.BirthDate, '2014-01-28') < 60
            then '50-59'
        else '60+'
    end as AgeGroup,
    c.YearlyIncome,
    case
        when c.YearlyIncome is null then 'Unknown'
        when c.YearlyIncome < 40000 then 'Low Income'
        when c.YearlyIncome < 80000 then 'Middle Income'
        else 'High Income'
    end as IncomeTier,
    c.TotalChildren,
    c.EnglishOccupation as Occupation,
    g.City as CustomerCity,
    g.EnglishCountryRegionName as CustomerCountry
from dbo.DimCustomer as c
left join dbo.DimGeography as g
    on c.GeographyKey = g.GeographyKey;
--Dim_Product

select
    p.ProductKey,
    p.ProductAlternateKey as ProductCode,
    p.EnglishProductName as ProductName,
    coalesce(p.Color, 'Unknown') as ProductColor,
    coalesce(p.Size, 'Unknown') as ProductSize,
    coalesce(p.ModelName, 'Unknown') as ModelName,
    coalesce(
        ps.EnglishProductSubcategoryName,
        'Other'
    ) as SubCategory,
    coalesce(
        pc.EnglishProductCategoryName,
        'Other'
    ) as Category,
    p.StandardCost,
    p.ListPrice,
    coalesce(p.Status, 'Unknown') as ProductStatus
from dbo.DimProduct as p
left join dbo.DimProductSubcategory as ps
    on p.ProductSubcategoryKey = ps.ProductSubcategoryKey
left join dbo.DimProductCategory as pc
    on ps.ProductCategoryKey = pc.ProductCategoryKey;

--Dim_Date

select
    DateKey,
    cast(FullDateAlternateKey as date) as Date,
    DayNumberOfMonth as Day,
    EnglishDayNameOfWeek as DayName,
    EnglishMonthName as MonthName,
    left(EnglishMonthName, 3) as MonthShort,
    MonthNumberOfYear as MonthNumber,
    concat('Q', CalendarQuarter) as Quarter,
    CalendarQuarter as QuarterNumber,
    CalendarYear as Year,
    concat(
        CalendarYear,
        '-',
        right(
            '0' + CAST(MonthNumberOfYear as varchar(2)),
            2
        )
    ) as YearMonth

from dbo.DimDate;

--Dim_Territory
select
    SalesTerritoryKey,
    SalesTerritoryRegion as Region,
    SalesTerritoryCountry as Country,
    SalesTerritoryGroup as TerritoryGroup
from dbo.DimSalesTerritory;