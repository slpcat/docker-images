BEGIN;
SET @vid = (SELECT MAX(valuemapid) AS id FROM valuemaps);
SET @mid = (SELECT MAX(mappingid) AS id FROM mappings);
INSERT INTO `valuemaps` 
(valuemapid,name) 
VALUES 
(@vid+1,'NTP Peer Status');
INSERT INTO `mappings` 
(mappingid,valuemapid,VALUE,newvalue) 
VALUES 
(@mid+1,@vid+1,'','Source discarded high stratum, failed sanity'),
(@mid+2,@vid+1,'#','Source selected, distance exceeds maximum value'),
(@mid+3,@vid+1,'*','Current time source'),
(@mid+4,@vid+1,'+','Source selected, included in final set'),
(@mid+5,@vid+1,'-','Source discarded by cluster algorithm'),
(@mid+6,@vid+1,'.','Source selected from end of candidate list'),
(@mid+7,@vid+1,'o','Source selected, PPS used'),
(@mid+8,@vid+1,'x','Source false ticker');
DELETE FROM ids WHERE TABLE_NAME='valuemaps' AND field_name='valuemapid';
DELETE FROM ids WHERE TABLE_NAME='mappings' AND field_name='mappingid';
COMMIT;
