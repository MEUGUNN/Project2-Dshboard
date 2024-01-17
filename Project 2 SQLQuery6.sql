--cleaning data in SQL Queries 

Select *
From [PROJECT 2].dbo.NashvilleHousing

--standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [PROJECT 2].dbo.NashvilleHousing

Update [PROJECT 2]..NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE [PROJECT 2]..NashvilleHousing
Add SaleDateConverted Date;

Select * 
From [PROJECT 2]..NashvilleHousing

Update [PROJECT 2]..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address data

Select *
From [PROJECT 2].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


-- Joing the data of the colums if the parcel id matches but the property address is Null 
--so populating the property address with parcel id address
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From [PROJECT 2].dbo.NashvilleHousing a
join [PROJECT 2].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is  null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.propertyAddress)
From [PROJECT 2].dbo.NashvilleHousing a
join [PROJECT 2].dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into induvidual colums(Address,city,sate)


Select PropertyAddress 
From [PROJECT 2].dbo.NashvilleHousing
order by ParcelID

select 
SUBSTRING ( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING ( PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN( PropertyAddress)) as Address
From [PROJECT 2].dbo.NashvilleHousing



ALTER TABLE [PROJECT 2]..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [PROJECT 2]..NashvilleHousing
SET PropertySplitAddress = SUBSTRING ( PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE [PROJECT 2]..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [PROJECT 2]..NashvilleHousing
SET PropertySplitCity = SUBSTRING ( PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN( PropertyAddress))

select * 
From [PROJECT 2].dbo.NashvilleHousing





select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
From [PROJECT 2]..NashvilleHousing



--spliting Address , city and state from the complete address 

ALTER TABLE [PROJECT 2]..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [PROJECT 2]..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE [PROJECT 2]..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [PROJECT 2]..NashvilleHousing
SET ownerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE [PROJECT 2]..NashvilleHousing
Add OwnerSplitstate Nvarchar(255);

Update [PROJECT 2]..NashvilleHousing
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

select *
From [PROJECT 2].dbo.NashvilleHousing



--change Y and N to Yes and No in "solid as vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PROJECT 2].. NashvilleHousing
Group by SoldAsVacant
order by 2



Select SoldAsVacant,
case when soldAsVacant = 'Y' then 'YES'
     when SoldAsVacant = 'N' then 'NO'
	 Else SoldAsVacant
	 END
From [PROJECT 2]..NashvilleHousing


Update [PROJECT 2]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

Select SoldAsVacant from [PROJECT 2]..NashvilleHousing

--Removing Duplicate Data from all datas in one go 

from [PROJECT 2]..NashvilleHousing


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [PROJECT 2]..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--Delete unused columns


Select *
From [PROJECT 2]..NashvilleHousing

ALTER TABLE [PROJECT 2]..NashvilleHousing
Drop COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter Table [PROJECT 2]..NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate