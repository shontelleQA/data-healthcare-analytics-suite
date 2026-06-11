# Dashboard Overview

## Purpose

This Power BI dashboard was created to visualize billing cycle delays and their financial impact across healthcare encounter types.

The dashboard is organized into three pages that guide users from a high-level summary to operational and financial analysis.

---

## Dashboard Pages

### Page 1 — Executive Summary

**Business Question:**

> Is there a billing delay problem and how significant is it?

Key metrics include:

* Average Billing Delay
* Total Claims
* Delayed Claims Percentage
* Delayed Cost Percentage

Visuals include:

* Average Delay by Encounter Type
* Delayed Claims Percentage by Encounter Type
* Delay Severity & Financial Impact Matrix
* Delayed Claim Cost Treemap

**Key Finding:**

* Only 5.87% of claims exceeded the 30-day threshold, but those claims represented 13.86% of total claim cost.

---

### Page 2 — Operational Analysis

**Business Question:**

> Where are delays occurring?

Visuals include:

* Claim Volume by Encounter Type
* Operational Metrics Matrix
* Delay Distribution Histogram

**Key Finding:**

* Billing delays are concentrated within inpatient and emergency encounters despite representing a relatively small share of total claim volume.

---

### Page 3 — Financial Impact Analysis

**Business Question:**

> What is the financial impact of delayed claims?

Key metrics include:

* Total Delayed Claim Cost
* Top Cost Driver Amount
* Delayed Cost Concentration Percentage

Visuals include:

* Delayed Claim Cost by Encounter Type
* Financial Impact Matrix
* Total Claim Cost Treemap

**Key Finding:**

* Inpatient and emergency encounters account for approximately 92.6% of delayed claim cost exposure.

---

## Interactive Features

Users can interact with the dashboard using:

* Encounter Type slicers
* Cross-filtering between visuals
* Interactive matrices and charts

Selections made within a page dynamically update related visuals and metrics.

---

## Dashboard Design Approach

The dashboard was intentionally structured around business questions rather than technical metrics.

Each page serves a distinct purpose:

1. Executive Summary – Understand the overall problem.
2. Operational Analysis – Identify where delays occur.
3. Financial Impact Analysis – Evaluate the business impact.

This structure mirrors how healthcare operations, revenue cycle, and leadership teams would typically investigate billing performance issues.

---

## Files

* `billing_delay_dashboard.pbix` – Power BI dashboard file
* `dashboard_page_1.png` – Executive Summary screenshot
* `dashboard_page_2.png` – Operational Analysis screenshot
* `dashboard_page_3.png` – Financial Impact Analysis screenshot
