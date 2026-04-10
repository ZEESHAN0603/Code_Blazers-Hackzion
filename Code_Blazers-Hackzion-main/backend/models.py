from sqlalchemy import Column, Integer, String, Float
from database import Base


class Transaction(Base):
    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    merchant = Column(String, nullable=False)
    amount = Column(Float, nullable=False)
    category = Column(String, nullable=False)
    date = Column(String, nullable=False)
    payment_method = Column(String, nullable=True)


class Subscription(Base):
    __tablename__ = "subscriptions"

    id = Column(Integer, primary_key=True, index=True)
    service_name = Column(String, nullable=False)
    amount = Column(Float, nullable=False)
    billing_cycle = Column(String, nullable=False)  # monthly, yearly, weekly


class Goal(Base):
    __tablename__ = "goals"

    id = Column(Integer, primary_key=True, index=True)
    goal_name = Column(String, nullable=False)
    target_amount = Column(Float, nullable=False)
    saved_amount = Column(Float, default=0.0)
