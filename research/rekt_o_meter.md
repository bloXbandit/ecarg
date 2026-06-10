# Rekt-o-Meter Concept

## Overview
A "Rekt-o-meter" for daily briefings that calculates a "Rekt Score" (0-100) based on crypto market performance and provides a snarky comment.

## Logic
- **Input:** List of crypto assets with their 24h % change (e.g., BTC, ETH, SOL).
- **Base Score Calculation:**
  - Calculate average daily % change of major coins.
  - Map average change to a score range:
    - **< -10%**: Score 90-100 ("Apocalypse Now")
    - **-5% to -10%**: Score 70-90 ("Pain Train")
    - **-2% to -5%**: Score 50-70 ("Oof")
    - **-2% to +2%**: Score 30-50 ("Flatline")
    - **> +2%**: Score 0-30 ("Moonbois rejoice")
- **Multipliers/Modifiers:**
  - If SOL is down > 10%: +10 to score (Solana outage/dump meme).
  - If BTC is down > 5%: +5 to score (Market leader drag).
  - If ETH is up > 5% while others down: -5 to score (The flippening? Probably not).

## Prototype Code (`src/rekt_o_meter.py`)

```python
import random

def calculate_rekt_score(prices):
    """
    Calculates a 'Rekt Score' based on crypto price changes.
    
    Args:
        prices (list of dict): List of assets, e.g., 
                               [{'symbol': 'BTC', 'change_24h': -5.2}, 
                                {'symbol': 'ETH', 'change_24h': -2.1},
                                {'symbol': 'SOL', 'change_24h': -12.5}]
                                
    Returns:
        dict: {'score': int, 'message': str, 'breakdown': str}
    """
    if not prices:
        return {'score': 0, 'message': "No data, no pain.", 'breakdown': "N/A"}

    # 1. Calculate Average Change
    changes = [p['change_24h'] for p in prices]
    avg_change = sum(changes) / len(changes)
    
    # 2. Determine Base Score & Category
    if avg_change < -10:
        base_score = random.randint(90, 100)
        category = "Apocalypse Now"
    elif -10 <= avg_change < -5:
        base_score = random.randint(70, 89)
        category = "Pain Train"
    elif -5 <= avg_change < -2:
        base_score = random.randint(50, 69)
        category = "Oof"
    elif -2 <= avg_change <= 2:
        base_score = random.randint(30, 49)
        category = "Flatline"
    else: # > +2% (Modified slightly from prompt to cover gap between 2 and 5, assuming positive is good)
        base_score = random.randint(0, 29)
        category = "Moonbois rejoice"

    final_score = base_score
    modifiers = []

    # 3. Apply Bonus Multipliers
    # Check specific coins if present
    for p in prices:
        sym = p['symbol'].upper()
        chg = p['change_24h']
        
        if sym == 'SOL' and chg < -10:
            final_score += 10
            modifiers.append("SOL nuke (+10)")
        
        if sym == 'BTC' and chg < -5:
            final_score += 5
            modifiers.append("BTC dump (+5)")
            
    # Cap score at 100, min 0
    final_score = max(0, min(100, final_score))
    
    return {
        'score': final_score,
        'message': category,
        'avg_change': avg_change,
        'modifiers': ", ".join(modifiers) if modifiers else "None"
    }

# Example Usage
if __name__ == "__main__":
    market_data = [
        {'symbol': 'BTC', 'change_24h': -3.5},
        {'symbol': 'ETH', 'change_24h': -1.2},
        {'symbol': 'SOL', 'change_24h': -11.0}
    ]
    
    result = calculate_rekt_score(market_data)
    print(f"Rekt Score: {result['score']}/100")
    print(f"Verdict: {result['message']}")
    print(f"Details: Avg Change {result['avg_change']:.2f}%, Modifiers: {result['modifiers']}")
```
