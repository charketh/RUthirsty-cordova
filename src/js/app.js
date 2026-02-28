const app = {
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    onDeviceReady: function() {
        console.log('Device ready');
        this.setupEventListeners();
        this.updateUI();
    },

    setupEventListeners: function() {
        const checkInBtn = document.getElementById('checkInBtn');
        checkInBtn.addEventListener('click', this.addRecord.bind(this));
    },

    getRecords: function() {
        const data = localStorage.getItem('ruthirsty_records');
        return data ? JSON.parse(data) : [];
    },

    saveRecords: function(records) {
        localStorage.setItem('ruthirsty_records', JSON.stringify(records));
    },

    formatDate: function(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    },

    formatTime: function(date) {
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        return `${hours}:${minutes}:${seconds}`;
    },

    formatDisplayDate: function(dateStr) {
        const date = new Date(dateStr);
        const today = new Date();
        const yesterday = new Date(today);
        yesterday.setDate(yesterday.getDate() - 1);

        if (this.formatDate(date) === this.formatDate(today)) {
            return '今天';
        } else if (this.formatDate(date) === this.formatDate(yesterday)) {
            return '昨天';
        } else {
            return dateStr;
        }
    },

    addRecord: function() {
        const now = new Date();
        const records = this.getRecords();

        const record = {
            timestamp: now.getTime(),
            date: this.formatDate(now),
            time: this.formatTime(now)
        };

        records.push(record);
        this.saveRecords(records);

        this.updateUI();
        this.vibrate();
    },

    deleteRecord: function(timestamp) {
        const records = this.getRecords();
        const filteredRecords = records.filter(r => r.timestamp !== timestamp);
        this.saveRecords(filteredRecords);
        this.updateUI();
    },

    getTodayCount: function(records) {
        const today = this.formatDate(new Date());
        return records.filter(r => r.date === today).length;
    },

    updateUI: function() {
        const records = this.getRecords();
        const todayCount = this.getTodayCount(records);
        const totalCount = records.length;

        document.getElementById('todayCount').textContent = todayCount;
        document.getElementById('totalCount').textContent = totalCount;

        this.renderRecords(records);
    },

    renderRecords: function(records) {
        const recordsList = document.getElementById('recordsList');

        if (records.length === 0) {
            recordsList.innerHTML = '<p class="empty-message">暂无打卡记录</p>';
            return;
        }

        const sortedRecords = [...records].sort((a, b) => b.timestamp - a.timestamp);
        const groupedRecords = this.groupByDate(sortedRecords);

        let html = '';
        for (const [date, dateRecords] of Object.entries(groupedRecords)) {
            html += `
                <div class="record-group">
                    <div class="record-group-header">${this.formatDisplayDate(date)}</div>
                    ${dateRecords.map(record => `
                        <div class="record-item">
                            <div class="record-icon">💧</div>
                            <div class="record-info">
                                <div class="record-date">${this.formatDisplayDate(record.date)}</div>
                                <div class="record-time">${record.time}</div>
                            </div>
                            <button class="record-delete" onclick="app.deleteRecord(${record.timestamp})" title="删除记录">
                                ×
                            </button>
                        </div>
                    `).join('')}
                </div>
            `;
        }

        recordsList.innerHTML = html;
    },

    groupByDate: function(records) {
        return records.reduce((groups, record) => {
            const date = record.date;
            if (!groups[date]) {
                groups[date] = [];
            }
            groups[date].push(record);
            return groups;
        }, {});
    },

    vibrate: function() {
        if (navigator.vibrate) {
            navigator.vibrate(50);
        }
    }
};

app.initialize();
