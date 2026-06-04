using System;

namespace MyNamespace
{
    /// <summary>
    /// Represents a sample calculator class to demonstrate DocFX table templates.
    /// </summary>
    public class Calculator
    {
        /// <summary>
        /// Gets or sets the name of the calculator instance.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets the current calculated value.
        /// </summary>
        public double CurrentValue { get; private set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="Calculator"/> class.
        /// </summary>
        /// <param name="name">The name of the calculator.</param>
        public Calculator(string name)
        {
            Name = name;
            CurrentValue = 0;
        }

        /// <summary>
        /// Adds a number to the current value.
        /// </summary>
        /// <param name="value">The number to add.</param>
        /// <returns>The updated current value.</returns>
        public double Add(double value)
        {
            CurrentValue += value;
            return CurrentValue;
        }

        /// <summary>
        /// Subtracts a number from the current value.
        /// </summary>
        /// <param name="value">The number to subtract.</param>
        /// <returns>The updated current value.</returns>
        public double Subtract(double value)
        {
            CurrentValue -= value;
            return CurrentValue;
        }

        /// <summary>
        /// Resets the calculator's current value to zero.
        /// </summary>
        public void Reset()
        {
            CurrentValue = 0;
        }
    }
}
