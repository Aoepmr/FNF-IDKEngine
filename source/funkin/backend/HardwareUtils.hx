package funkin.backend;

import cpp.SizeT;
import hxhardware.*;

class HardwareUtils
{
	public static function initCPU():Void
		CPU.init();

	// ----------------- CPU / GPU (RAW) -----------------

	public static function getProcessCPUUsageRaw():Float
		return CPU.getProcessCPUUsage();

	public static function getSystemCPUUsageRaw():Float
		return CPU.getSystemTotalCPUUsage();

	public static function getGPUUsageRaw():Float
		return GPU.getSystemTotalGPUUsage();

	// ----------------- CPU / GPU (FORMATTED) -----------------

	public static function getProcessCPUUsage(?fixed:Int = 2):Float
		return roundDecimal(getProcessCPUUsageRaw(), fixed);

	public static function getSystemCPUUsage(?fixed:Int = 2):Float
		return roundDecimal(getSystemCPUUsageRaw(), fixed);

	public static function getGPUUsage(?fixed:Int = 2):Float
		return roundDecimal(getGPUUsageRaw(), fixed);

	// ----------------- MEMORY (RAW) ----------------

	public static function getProcessMemoryRaw():SizeT
		return Memory.getProcessPhysicalMemoryUsage();

	public static function getSystemMemoryRaw():SizeT
		return Memory.getSystemPhysicalMemoryUsage();

	// ----------------- MEMORY (FORMATTED) -----------------

	public static function getProcessMemory(?fixed:Int = 2):String
		return formatBytes(getProcessMemoryRaw(), fixed);

	public static function getSystemMemory(?fixed:Int = 2):String
		return formatBytes(getSystemMemoryRaw(), fixed);

	// ----------------- UTILS -----------------

	static function roundDecimal(Value:Float, Precision:Int):Float
	{
		if (Precision <= 0)
			return Math.round(Value);

		var mult:Float = 1;
		for (i in 0...Precision)
			mult *= 10;

		return Math.round(Value * mult) / mult;
	}

	static function formatBytes(Bytes:Float, Precision:Int = 2):String
	{
		var units = ["Bytes", "kB", "MB", "GB", "TB", "PB"];
		var curUnit = 0;

		while (Bytes >= 1024 && curUnit < units.length - 1)
		{
			Bytes /= 1024;
			curUnit++;
		}

		return roundDecimal(Bytes, Precision) + units[curUnit];
	}
}
