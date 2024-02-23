within ClaRaDelay.Examples;
model ExampleClaRaDelay

  parameter Real samplePeriod = 0.1;
  parameter Integer nHistoricElements = 5;

  Real signal = sin(2*Modelica.Constants.pi*time);

  import gdv = ClaRaDelay.getDelayValuesAtTime;

  //////////////////////////////////////////////////////////////////////////////////
  //ExternalTable for ClaRaDelay
  //Note: in contrast to Modelica delay we need only 1 delay-table pointer
  //////////////////////////////////////////////////////////////////////////////////
  ClaRaDelay.ExternalTable claraTablePointer=
      ClaRaDelay.ExternalTable();

  //////////////////////////////////////////////////////////////////////////////////
  //DelayTimes for ClaRaDelay
  //Note: Modelica delay(u[i],delayTime) expects delayTime to the difference between current time and past instance of time
  //      for which the delayed signal should be obtaind: delayTime=time - pastTime
  //      In contrast to that ClaRaDelay takes a vector of pastTimes: pastTime = time - delayTime
  //////////////////////////////////////////////////////////////////////////////////
  Real[nHistoricElements] delayTimes={max(0, time - samplePeriod*(t - 1)) for t in 1:nHistoricElements};

  Real[nHistoricElements] delayedSignals;

equation

  // call the delay method with the pointer and the delay times.
  for t in 1:nHistoricElements loop
    delayedSignals[t] = gdv(
                claraTablePointer,
                time,
                signal,
                delayTimes[t]);
  end for;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Bitmap(extent={{-100,-100},{100,100}}, fileName="modelica://ClaRaDelay/Resources/Images/Packages/ExecutableExample_b80.png")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This example model demonstrates the usage of the ClaRaDelay and highlights the difference to th convetional delay.</p>
<p>The signal should be delayed several times into <span style=\"font-family: Courier New;\">delayedSignals. </span>This can be achieved with a single reference table.</p>
</html>"),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end ExampleClaRaDelay;
