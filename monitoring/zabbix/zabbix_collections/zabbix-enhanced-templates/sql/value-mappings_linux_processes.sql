BEGIN;
SET @vid = (SELECT MAX(valuemapid) AS id FROM valuemaps);
SET @mid = (SELECT MAX(mappingid) AS id FROM mappings);
INSERT INTO `valuemaps` 
(valuemapid,name) 
VALUES 
(@vid+1,'Linux Process State');
INSERT INTO `mappings` 
(mappingid,valuemapid,VALUE,newvalue) 
VALUES 
(@mid+1,@vid+1,'D','Sleeping_Wait'),
(@mid+2,@vid+1,'R','Running'),
(@mid+3,@vid+1,'S','Sleeping'),
(@mid+4,@vid+1,'T','Traced/Stopped'),
(@mid+5,@vid+1,'Z','Zombie');
DELETE FROM ids WHERE TABLE_NAME='valuemaps' AND field_name='valuemapid';
DELETE FROM ids WHERE TABLE_NAME='mappings' AND field_name='mappingid';
COMMIT;
