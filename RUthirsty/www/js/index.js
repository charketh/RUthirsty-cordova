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

// 喝水打卡应用
const DrinkApp = {
    storageKey: 'drinkRecords',

    // 初始化应用
    init: function() {
        this.loadRecords();
        this.updateUI();
        this.bindEvents();
    },

    // 绑定事件
    bindEvents: function() {
        const drinkButton = document.getElementById('drinkButton');
        if (drinkButton) {
            drinkButton.addEventListener('click', () => this.addDrinkRecord());
        }
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

    // 添加喝水记录
    addDrinkRecord: function() {
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

        // 添加按钮点击反馈
        const button = document.getElementById('drinkButton');
        button.style.transform = 'scale(0.9)';
        setTimeout(() => {
            button.style.transform = 'scale(1)';
        }, 200);
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

    // 更新今日喝水次数
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
                        <span class="record-icon">💧</span>
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
    DrinkApp.init();
}

// 如果不是在Cordova环境中，直接初始化（用于浏览器测试）
if (!window.cordova) {
    document.addEventListener('DOMContentLoaded', function() {
        DrinkApp.init();
    });
}
