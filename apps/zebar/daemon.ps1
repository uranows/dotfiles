Add-Type @'
using System;using System.Collections.Generic;using System.Runtime.InteropServices;
public class ZDaemon{
  [DllImport("user32.dll")]public static extern bool SetWindowPos(IntPtr h,IntPtr a,int x,int y,int w,int ht,uint f);
  [DllImport("user32.dll")]public static extern bool EnumWindows(EnumWinProc cb,IntPtr lp);
  [DllImport("user32.dll")]public static extern uint GetWindowThreadProcessId(IntPtr h,out uint pid);
  [DllImport("user32.dll")]public static extern bool IsWindowVisible(IntPtr h);
  public delegate bool EnumWinProc(IntPtr h,IntPtr lp);
  public static void FixZOrder(){
    var pids=new HashSet<uint>();
    foreach(var p in System.Diagnostics.Process.GetProcessesByName("zebar"))pids.Add((uint)p.Id);
    EnumWindows((h,lp)=>{
      uint pid;GetWindowThreadProcessId(h,out pid);
      if(pids.Contains(pid)&&IsWindowVisible(h))
        SetWindowPos(h,(IntPtr)(-1),0,0,0,0,0x0001|0x0002|0x0010);
      return true;
    },IntPtr.Zero);
  }
}
'@

$btFile = "$env:TEMP\zebar-bt.txt"
$tick = 0

while ($true) {
  # Exit if zebar is no longer running
  if (-not (Get-Process -Name zebar -ErrorAction SilentlyContinue)) { exit }

  [ZDaemon]::FixZOrder()

  if ($tick % 12 -eq 0) {
    try {
      $val = Get-PnpDevice -FriendlyName '*soundcore*' | ForEach-Object {
        ($_ | Get-PnpDeviceProperty -KeyName '{104EA319-6EE2-4701-BD47-8DDBF425BBE5} 2' -EA SilentlyContinue |
          Where-Object Type -ne Empty).Data
      } | Where-Object { $_ } | Select-Object -First 1

      if ($val) {
        $val | Out-File $btFile -NoNewline
      } else {
        'null' | Out-File $btFile -NoNewline
      }
    } catch {
      'null' | Out-File $btFile -NoNewline
    }
  }

  $tick++
  Start-Sleep -Seconds 5
}
