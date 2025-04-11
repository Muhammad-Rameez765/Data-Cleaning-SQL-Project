/*

Cleaning Data in SQL Queries

*/


Select *
From [Portfolio Projects].[dbo].[NashVille_Housing]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


--Select saleDate, CONVERT(Date,SaleDate)
--From [Portfolio Projects].[dbo].[NashVille_Housing]


--Update NashvilleHousing
--SET SaleDate = CONVERT(Date,SaleDate)

-- View conversion preview
-- Preview sale date conversion
SELECT SaleDate, CONVERT(DATE, SaleDate) AS SaleDateConverted
FROM [Portfolio Projects].[dbo].[NashVille_Housing];

-- Update the original column if SaleDate is convertible
UPDATE [Portfolio Projects].[dbo].[NashVille_Housing]
SET SaleDate = CONVERT(DATE, SaleDate)
WHERE ISDATE(SaleDate) = 1;




-- If it doesn't Update properly

--ALTER TABLE NashVille_Housing
--Add SaleDateConverted Date;

--Update NashVille_Housing
--SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portfolio Projects].[dbo].[NashVille_Housing]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Projects].[dbo].[NashVille_Housing] a
JOIN [Portfolio Projects].[dbo].[NashVille_Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Projects].[dbo].[NashVille_Housing] a
JOIN [Portfolio Projects].[dbo].[NashVille_Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Portfolio Projects].[dbo].[NashVille_Housing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio Projects].[dbo].[NashVille_Housing]


ALTER TABLE [Portfolio Projects].[dbo].[NashVille_Housing]
Add PropertySplitAddress Nvarchar(255);


ALTER TABLE [Portfolio Projects].[dbo].[NashVille_Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Projects].[dbo].[NashVille_Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Projects].[dbo].[NashVille_Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Portfolio Projects].[dbo].[NashVille_Housing]





Select OwnerAddress
From [Portfolio Projects].[dbo].[NashVille_Housing]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio Projects].[dbo].[NashVille_Housing]



ALTER TABLE [Portfolio Projects].[dbo].[NashVille_Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Projects].[dbo].[NashVille_Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio Projects].[dbo].[NashVille_Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Projects].[dbo].[NashVille_Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio Projects].[dbo].[NashVille_Housing]
Add OwnerSplitState Nvarchar(255);

Update [Portfolio Projects].[dbo].[NashVille_Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)




Select *
From [Portfolio Projects].[dbo].[NashVille_Housing]




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Projects].[dbo].[NashVille_Housing]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Projects].[dbo].[NashVille_Housing]


Update [Portfolio Projects].[dbo].[NashVille_Housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

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

From [Portfolio Projects].[dbo].[NashVille_Housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio Projects].[dbo].[NashVille_Housing]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Portfolio Projects].[dbo].[NashVille_Housing]


ALTER TABLE [Portfolio Projects].[dbo].[NashVille_Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
















