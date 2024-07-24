import asyncio
import websockets
import json
import random

async def simulate_user(user_id):
    uri = "ws://localhost:8000/ws"
    async with websockets.connect(uri) as websocket:
        print(f"User {user_id} connected")

        # Subscribe to main view
        await websocket.send(json.dumps({
            "type": "subscribe",
            "category": "main_view"
        }))

        # Simulate receiving messages
        try:
            while True:
                response = await asyncio.wait_for(websocket.recv(), timeout=5.0)
                print(f"User {user_id} received: {response}")

                # Randomly subscribe to a stock every 10 seconds
                if random.random() < 0.1:
                    stock = random.choice(["SSI", "VNM", "VIC"])
                    await websocket.send(json.dumps({
                        "type": "subscribe",
                        "category": "stock",
                        "symbol": stock
                    }))
                    print(f"User {user_id} subscribed to {stock}")

        except asyncio.TimeoutError:
            print(f"User {user_id} connection timed out")

async def main():
    await asyncio.gather(
        simulate_user(1),
        simulate_user(2)
    )

if __name__ == "__main__":
    asyncio.run(main())