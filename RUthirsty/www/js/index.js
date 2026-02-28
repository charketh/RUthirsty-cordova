/**
    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
*/

// 停车打卡应用
const ParkingApp = {
    storageKey: 'parkingRecords',
    currentDate: new Date(),
    currentView: 'list',

    // 初始化应用
    init: function() {
        this.loadRecords();
        this.updateUI();
        this.bindEvents();
    },

    // 绑定事件
    bindEvents: function() {
        const parkingButton = document.getElementById('parkingButton');
        if (parkingButton) {
            parkingButton.addEventListener('click', () => this.addParkingRecord());
        }

        // 视图切换
        const listViewBtn = document.getElementById('listViewBtn');
        const calendarViewBtn = document.getElementById('calendarViewBtn');
        if (listViewBtn) {
            listViewBtn.addEventListener('click', () => this.switchView('list'));
        }
        if (calendarViewBtn) {
            calendarViewBtn.addEventListener('click', () => this.switchView('calendar'));
        }

        // 日历导航
        const prevMonth = document.getElementById('prevMonth');
        const nextMonth = document.getElementById('nextMonth');
        if (prevMonth) {
            prevMonth.addEventListener('click', () => this.changeMonth(-1));
        }
        if (nextMonth) {
            nextMonth.addEventListener('click', () => this.changeMonth(1));
        }
    },

    // 切换视图
    switchView: function(view) {
        this.currentView = view;

        const listView = document.getElementById('listView');
        const calendarView = document.getElementById('calendarView');
        const listBtn = document.getElementById('listViewBtn');
        const calendarBtn = document.getElementById('calendarViewBtn');

        if (view === 'list') {
            listView.style.display = 'block';
            calendarView.style.display = 'none';
            listBtn.classList.add('active');
            calendarBtn.classList.remove('active');
        } else {
            listView.style.display = 'none';
            calendarView.style.display = 'block';
            listBtn.classList.remove('active');
            calendarBtn.classList.add('active');
            this.renderCalendar();
        }
    },

    // 切换月份
    changeMonth: function(delta) {
        this.currentDate.setMonth(this.currentDate.getMonth() + delta);
        this.renderCalendar();
    },

    // 渲染日历
    renderCalendar: function() {
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();

        // 更新月份标题
        const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
        const monthElement = document.getElementById('currentMonth');
        if (monthElement) {
            monthElement.textContent = `${year}年${monthNames[month]}`;
        }

        // 获取当月第一天和最后一天
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        const firstDayWeek = firstDay.getDay();
        const daysInMonth = lastDay.getDate();

        // 获取打卡记录
        const records = this.getRecords();
        const checkinDates = new Set(records.map(r => r.date));

        // 生成日历格子
        const grid = document.getElementById('calendarGrid');
        if (!grid) return;

        grid.innerHTML = '';

        // 填充上月日期
        const prevMonthLastDay = new Date(year, month, 0).getDate();
        for (let i = firstDayWeek - 1; i >= 0; i--) {
            const day = prevMonthLastDay - i;
            const cell = this.createDayCell(day, true, false, false);
            grid.appendChild(cell);
        }

        // 填充当月日期
        const today = new Date();
        const isCurrentMonth = today.getFullYear() === year && today.getMonth() === month;

        for (let day = 1; day <= daysInMonth; day++) {
            const dateStr = this.formatDate(new Date(year, month, day));
            const isToday = isCurrentMonth && today.getDate() === day;
            const hasCheckin = checkinDates.has(dateStr);
            const cell = this.createDayCell(day, false, isToday, hasCheckin);
            grid.appendChild(cell);
        }

        // 填充下月日期
        const remainingCells = 42 - (firstDayWeek + daysInMonth);
        for (let day = 1; day <= remainingCells; day++) {
            const cell = this.createDayCell(day, true, false, false);
            grid.appendChild(cell);
        }
    },

    // 创建日期单元格
    createDayCell: function(day, isOtherMonth, isToday, hasCheckin) {
        const cell = document.createElement('div');
        cell.className = 'calendar-day';
        if (isOtherMonth) cell.classList.add('other-month');
        if (isToday) cell.classList.add('today');
        if (hasCheckin) cell.classList.add('has-checkin');
        cell.textContent = day;
        return cell;
    },

    // 获取所有记录
    getRecords: function() {
        try {
            const records = localStorage.getItem(this.storageKey);
            return records ? JSON.parse(records) : [];
        } catch (e) {
            console.error('读取记录失败:', e);
            return [];
        }
    },

    // 保存记录
    saveRecords: function(records) {
        try {
            localStorage.setItem(this.storageKey, JSON.stringify(records));
        } catch (e) {
            console.error('保存记录失败:', e);
        }
    },

    // 添加停车记录
    addParkingRecord: function() {
        const now = new Date();
        const record = {
            id: Date.now(),
            timestamp: now.getTime(),
            date: this.formatDate(now),
            time: this.formatTime(now)
        };

        const records = this.getRecords();
        records.unshift(record);
        this.saveRecords(records);
        this.updateUI();

        // 如果在日历视图，刷新日历
        if (this.currentView === 'calendar') {
            this.renderCalendar();
        }

        // 添加按钮点击反馈
        const button = document.getElementById('parkingButton');
        if (button) {
            button.style.transform = 'scale(0.9)';
            setTimeout(() => {
                button.style.transform = 'scale(1)';
            }, 200);
        }
    },

    // 加载记录
    loadRecords: function() {
        this.records = this.getRecords();
    },

    // 更新UI
    updateUI: function() {
        this.updateTodayCount();
        this.renderRecordsList();
    },

    // 更新今日停车次数
    updateTodayCount: function() {
        const records = this.getRecords();
        const today = this.formatDate(new Date());
        const todayRecords = records.filter(record => record.date === today);

        const countElement = document.getElementById('todayCount');
        if (countElement) {
            countElement.textContent = todayRecords.length;
        }
    },

    // 渲染记录列表
    renderRecordsList: function() {
        const records = this.getRecords();
        const listElement = document.getElementById('recordsList');

        if (!listElement) return;

        if (records.length === 0) {
            listElement.innerHTML = '<div class="empty-message">还没有打卡记录，点击上方按钮开始打卡吧！</div>';
            return;
        }

        let html = '';
        records.forEach(record => {
            html += `
                <div class="record-item">
                    <div style="display: flex; align-items: center;">
                        <span class="record-icon">🅿️</span>
                        <div>
                            <div class="record-time">${record.time}</div>
                            <div class="record-date">${record.date}</div>
                        </div>
                    </div>
                </div>
            `;
        });

        listElement.innerHTML = html;
    },

    // 格式化日期 (YYYY-MM-DD)
    formatDate: function(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    },

    // 格式化时间 (HH:MM:SS)
    formatTime: function(date) {
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        return `${hours}:${minutes}:${seconds}`;
    }
};

// Cordova设备就绪事件
document.addEventListener('deviceready', onDeviceReady, false);

function onDeviceReady() {
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    ParkingApp.init();
}

// 如果不是在Cordova环境中，直接初始化（用于浏览器测试）
if (!window.cordova) {
    document.addEventListener('DOMContentLoaded', function() {
        ParkingApp.init();
    });
}
