-- ⚠️ DANGEROUS: Database cleanup script for Vietnamese Stock Market
-- This will DELETE all stocks and indexes not in the configured symbols list
-- BACKUP YOUR DATABASE BEFORE RUNNING THIS!

-- Delete stocks not in configured list
DELETE FROM stocks 
WHERE symbol NOT IN ('DXG','HSG','TVN','VNM','PNJ','SAB','HPG','ITD','VJC','POW','TCB','EIB','FRT','GAS','TPB','MBB','PDR','SBT','VIC','DHG','MWG','NKG','CTG','PME','BID','ACB','STB','FPT','CMG','NVL','ELC','BCM','BHN','PLX','VPB','KDC','VCB','MCH','IMP','POM','HVN','MSN','KDH','PVT','REE','NT2','VRE','GMD','VHM')
AND market_id IN (
    SELECT id FROM markets WHERE name IN ('HOSE', 'HNX', 'UPCOM')
);

-- Delete indexes not in configured list  
DELETE FROM indexes 
WHERE symbol NOT IN ('VNAllShare','VN30','HNXCon','HNXLCap','VNSmallCap','UpcomIndex','VNIndex','HNX30','HNXMSci','HNXFin','VNMidCap','HNXIndex')
AND market_id IN (
    SELECT id FROM markets WHERE name IN ('HOSE', 'HNX', 'UPCOM')
);

-- Show remaining counts
SELECT 'Remaining stocks:', COUNT(*) FROM stocks s 
JOIN markets m ON s.market_id = m.id 
WHERE m.name IN ('HOSE', 'HNX', 'UPCOM');

SELECT 'Remaining indexes:', COUNT(*) FROM indexes i 
JOIN markets m ON i.market_id = m.id 
WHERE m.name IN ('HOSE', 'HNX', 'UPCOM');
