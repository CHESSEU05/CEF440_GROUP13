// Mock data for Cameroon network operations

export const complaintsByDayData = [
    { day: "Mon, May 20", total: 78, social: 32, calls: 28, billing: 18 },
    { day: "Tue, May 21", total: 92, social: 41, calls: 30, billing: 21 },
    { day: "Wed, May 22", total: 65, social: 25, calls: 22, billing: 18 },
    { day: "Thu, May 23", total: 87, social: 38, calls: 29, billing: 20 },
    { day: "Fri, May 24", total: 105, social: 48, calls: 35, billing: 22 },
    { day: "Sat, May 25", total: 70, social: 30, calls: 25, billing: 15 },
    { day: "Sun, May 26", total: 53, social: 20, calls: 18, billing: 15 },
  ]
  
  export const networkMetricsData = {
    signal: {
      average: -74.7,
      trend: -2.3,
      daily: [-72.5, -73.8, -74.2, -75.1, -74.9, -75.3, -76.8],
    },
    latency: {
      average: 81.9,
      trend: 3.5,
      daily: [78.2, 79.5, 80.1, 82.3, 83.7, 84.2, 85.1],
    },
    throughput: {
      average: 156.3,
      trend: 12.8,
      daily: [142.5, 148.7, 152.3, 158.9, 160.2, 163.5, 168.1],
    },
    errorRate: {
      average: 2.1,
      trend: 0.2,
      daily: [1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4],
    },
  }
  
  export const locationData = [
    { name: "Douala", complaints: 215, percentage: 28 },
    { name: "Yaoundé", complaints: 187, percentage: 24 },
    { name: "Bamenda", complaints: 124, percentage: 16 },
    { name: "Bafoussam", complaints: 98, percentage: 13 },
    { name: "Garoua", complaints: 76, percentage: 10 },
    { name: "Others", complaints: 70, percentage: 9 },
  ]
  
  export const feedbackData = {
    overall: 4.2,
    total: 2847,
    breakdown: {
      5: 60,
      4: 25,
      3: 10,
      2: 3,
      1: 2,
    },
    satisfaction: {
      current: 84,
      trend: 5,
      monthly: [76, 78, 79, 81, 82, 84],
    },
    categories: {
      "Network Coverage": { score: 3.8, trend: 0.2 },
      "Call Quality": { score: 4.1, trend: 0.3 },
      "Data Speed": { score: 3.9, trend: -0.1 },
      "Customer Support": { score: 4.5, trend: 0.4 },
      "Value for Money": { score: 3.7, trend: 0.1 },
    },
  }
  
  export const reportsList = [
    {
      id: "npr-2024-06",
      title: "Network Performance Report",
      description: "Comprehensive analysis of network performance metrics",
      date: "Jun 2, 2024 10:30 AM",
      type: "network",
      metrics: {
        latency: { value: 42, trend: -5 },
        throughput: { value: 156, trend: 12 },
        errorRate: { value: 2.1, trend: 0.2 },
      },
    },
    {
      id: "uea-2024-06",
      title: "User Engagement Analysis",
      description: "Analysis of user engagement and satisfaction metrics",
      date: "Jun 1, 2024 2:15 PM",
      type: "user",
      metrics: {
        activeUsers: { value: 28450, trend: 1250 },
        avgSessionTime: { value: 24, trend: 3 },
        retentionRate: { value: 78, trend: 2 },
      },
    },
    {
      id: "dus-2024-05",
      title: "Device Usage Statistics",
      description: "Analysis of device types and usage patterns",
      date: "May 30, 2024 9:45 AM",
      type: "device",
      metrics: {
        androidUsers: { value: 65, trend: 2 },
        iosUsers: { value: 32, trend: -1 },
        otherUsers: { value: 3, trend: -1 },
      },
    },
    {
      id: "ctr-2024-05",
      title: "Coverage Troubleshooting Report",
      description: "Analysis of coverage issues and resolution strategies",
      date: "May 28, 2024 11:20 AM",
      type: "network",
      metrics: {
        coverageIssues: { value: 87, trend: -12 },
        resolutionRate: { value: 92, trend: 4 },
        avgResolutionTime: { value: 36, trend: -8 },
      },
    },
    {
      id: "rtr-2024-05",
      title: "Regional Traffic Report",
      description: "Analysis of network traffic by region",
      date: "May 25, 2024 3:45 PM",
      type: "network",
      metrics: {
        doualaTraffic: { value: 42, trend: 5 },
        yaoundeTraffic: { value: 38, trend: 3 },
        otherRegionsTraffic: { value: 20, trend: -8 },
      },
    },
  ]
  