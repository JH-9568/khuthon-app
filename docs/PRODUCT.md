# PRODUCT.md

## Service Name

Flex

## One-line Description

A mobile app that helps users rethink overconsumption by comparing eating-out costs with home-cooking costs, converting saved money into virtual points, saving consumption decisions, ranking users by total savings, and letting users safely flex inside the app.

## Problem

Popular culture and mass media constantly promote luxury lifestyles, expensive food, flex culture, and image-driven consumption.

Users are repeatedly exposed to content that makes overconsumption feel normal or desirable. As a result, they may spend money not because they truly need something, but because they are influenced by social trends and media-driven standards.

The core issue is not just spending money. The real problem is that mass media creates a distorted standard of what is desirable, successful, or socially impressive.

## Target Users

- Young users who frequently spend money on eating out or delivery food
- Users influenced by SNS, influencers, and flex culture
- Users who want to save money but need stronger motivation
- Users who enjoy gamified habit-building apps
- Users who want to compare spending choices before making a purchase

## Core Concept

Do not flex wastefully in real life. Flex safely inside the app with the money you saved.

The app turns a spending decision into a visible game-like consequence:

- Cooking at home increases virtual balance and reward points.
- Eating out decreases virtual balance.
- Saved money improves the character state.
- Overspending makes the character poorer.
- Reward points can be used to buy in-app flex items.

## MVP Features

1. Nickname-based login
2. Persistent user profile with Supabase
3. Food name input
4. Eating-out price input
5. LLM-based home-cooking cost estimation
6. LLM-based ingredient and recipe generation
7. Saving amount calculation
8. Reward point calculation
9. User decision saving
10. Consumption record history
11. User stats: total saved amount, reward points, virtual balance
12. Ranking by total saved amount
13. Flex shop item list
14. Flex item purchase with reward points
15. Owned item list
16. Character state change based on virtual balance
17. Warning message that encourages mindful spending
18. Fallback mock data when LLM fails

## Out of Scope for MVP

- Real payment
- Real bank account integration
- Email/password authentication
- OAuth login
- Real-time supermarket price crawling
- Map-based shopping route
- Production-grade recommendation engine
- Advanced user profile system

## Success Criteria

The demo is successful if the following flow works:

1. User logs in with nickname.
2. App loads the user profile from Supabase.
3. User enters a food name and eating-out price.
4. Backend generates home-cooking cost, ingredients, recipe, and warning message using LLM or fallback.
5. App displays the comparison result.
6. User chooses either cook at home or eat out.
7. Backend saves the decision to Supabase.
8. User stats update.
9. Ranking reflects updated total savings.
10. User can buy flex items with reward points.
11. Purchased items are saved and displayed.