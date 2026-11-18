C:\github\icmonangular\src\app\features\schedule\presentation\pages\schedule-list\schedule-list.component.html
 
 <div class="col-md-2">
        <label class="form-label"> &nbsp; {{ 'schedule.list.group' | translate }}</label>
        <select class="form-select" [(ngModel)]="groupId" (ngModelChange)="onGroupChange()">
          <option value="">{{ 'schedule.list.all' | translate }} {{ 'schedule.list.group' | translate }}</option>
          <option *ngFor="let g of groups" [value]="g.id">{{ g.name }}</option>
        </select>
      </div>


 groups ส่งค่า relation ไป zones
      
      <div class="col-md-2">
        <label class="form-label"> &nbsp; {{ 'schedule.list.zone' | translate }}</label>
        <select class="form-select" [(ngModel)]="zoneId" (ngModelChange)="onZoneChange()">
          <option value="">{{ 'schedule.list.all' | translate }} {{ 'schedule.list.zone' | translate }}</option>
          <option *ngFor="let z of zones" [value]="z.id">{{ z.name }}</option>
        </select>
      </div>

 zones ส่งค่า relation ไป  areas
      
      <div class="col-md-2">
        <label class="form-label"> &nbsp; {{ 'schedule.list.area' | translate }}</label>
        <select class="form-select" [(ngModel)]="areaId" (ngModelChange)="search()">
          <option value="">{{ 'schedule.list.all' | translate }} {{ 'schedule.list.area' | translate }}</option>
          <option *ngFor="let a of areas" [value]="a.id">{{ a.name }}</option>
        </select>
      </div>

-----------------

SELECT  *
FROM erp_authentications a
LEFT JOIN erp_refresh_tokens rt ON rt.authentication_id = a.id
WHERE 1=1 
and a.user_id = 10000000004
ORDER BY a.last_update_at DESC
