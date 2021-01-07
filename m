Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBDB2ECA9A
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 07:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbhAGGkE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 01:40:04 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:30997 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbhAGGkE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 01:40:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610001429;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
        Subject:Sender;
        bh=11Gv/TiV/9ELIGwBkPM9E2AjpWsPmNDRhpUtDmGJV98=;
        b=X/pNNzyhB73wi9LsySYUUjLPGjnTrWdPQS+0f1lQyPwtASBN22dJ9ExDLUTd/KzYzr
        11zfch9P/VQpz4ADU8uN7+2Nb+LCgBIG3hMLC+gyNem1eF4DEoZoMvmXpBW0n5PqxpZh
        M1BNO/bCluL0HGhBmxrrW/Jz6OnsVPHCFUXqvuEzMs+NnN8hOaXOxxZuul5g4ARFvJZC
        fpp1O2ra/u5OGXcHG2Ei62/wzWGjQpJRcBGZSg2yjG96RimM8MNo7PCiYyY3dcDxeQ77
        jkyCpXezoSudqZr3P/cN4TBUFkWnWeG4ud3o+M8WWMJQCeRuNgdXSh3YuWBB8BipZRE6
        V3BA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShPkMRYMkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x076b6C3b
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 7 Jan 2021 07:37:06 +0100 (CET)
Message-ID: <3f8cda66411d4e82074808657df7f1bbbcff37a9.camel@chronox.de>
Subject: Re: [PATCH 0/5] Add KDF implementations to crypto API
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Date:   Thu, 07 Jan 2021 07:37:05 +0100
In-Reply-To: <X/OUt7+wGGEPkWh8@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
         <X/OUt7+wGGEPkWh8@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Am Montag, dem 04.01.2021 um 14:20 -0800 schrieb Eric Biggers:
> On Mon, Jan 04, 2021 at 10:45:57PM +0100, Stephan Müller wrote:
> > The HKDF addition is used to replace the implementation in the filesystem
> > crypto extension. This code was tested by using an EXT4 encrypted file
> > system that was created and contains files written to by the current
> > implementation. Using the new implementation a successful read of the
> > existing files was possible and new files / directories were created
> > and read successfully. These newly added file system objects could be
> > successfully read using the current code. Yet if there is a test suite
> > to validate whether the invokcation of the HKDF calculates the same
> > result as the existing implementation, I would be happy to validate
> > the implementation accordingly.
> 
> See https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html#tests
> for how to run the fscrypt tests.  'kvm-xfstests -c ext4 generic/582' should
> be
> enough for this, though you could run all the tests if you want.

I ran the $(kvm-xfstests -c encrypt -g auto) on 5.11-rc2 with and without my
HKDF changes. I.e. the testing shows the same results for both kernels which
seems to imply that my HKDF changes do not change the behavior.

I get the following errors in both occasions - let me know if I should dig a
bit more.


[failed, exit status 1] [06:19:21]- output mismatch (see
/results/ext4/results-encrypt/ext4/023.out.bad)
    --- tests/ext4/023.out      2020-03-20 02:31:32.000000000 +0000
    +++ /results/ext4/results-encrypt/ext4/023.out.bad  2021-01-07
06:19:21.292339438 +0000
    @@ -1,3 +1,2 @@
     QA output created by 023
     Format and populate
    -Mount
    ...
    (Run 'diff -u /root/xfstests/tests/ext4/023.out /results/ext4/results-
encrypt/ext4/023.out.bad'  to see the entire )

[failed, exit status 1] [06:19:28]- output mismatch (see
/results/ext4/results-encrypt/ext4/028.out.bad)
    --- tests/ext4/028.out      2020-03-20 02:31:32.000000000 +0000
    +++ /results/ext4/results-encrypt/ext4/028.out.bad  2021-01-07
06:19:28.762339424 +0000
    @@ -1,3 +1,2 @@
     QA output created by 028
     Format and mount
    -Compare fsmap
    ...
    (Run 'diff -u /root/xfstests/tests/ext4/028.out /results/ext4/results-
encrypt/ext4/028.out.bad'  to see the entire )

[failed, exit status 1] [06:21:02]- output mismatch (see
/results/ext4/results-encrypt/ext4/044.out.bad)
    --- tests/ext4/044.out      2020-03-20 02:31:32.000000000 +0000
    +++ /results/ext4/results-encrypt/ext4/044.out.bad  2021-01-07
06:21:02.215672727 +0000
    @@ -1,2 +1,5 @@
     QA output created by 044
     Silence is golden
    +mount: /vdc: wrong fs type, bad option, bad superblock on /dev/vdc,
missing codepage or helper program, or other e.
    +ext3 mount failed
    +(see /results/ext4/results-encrypt/ext4/044.full for details)
    ...
    (Run 'diff -u /root/xfstests/tests/ext4/044.out /results/ext4/results-
encrypt/ext4/044.out.bad'  to see the entire )


generic/085             [06:32:40][  849.654788] run fstests generic/085 at
2021-01-07 06:32:40
[  849.903286] EXT4-fs (vdd): Test dummy encryption mode enabled
[  849.915355] EXT4-fs (vdd): mounted filesystem with ordered data mode. Opts:
acl,user_xattr,block_validity,test_dummy.
[  850.267282] dm-0: detected capacity change from 524288 to 0
[  850.369101] EXT4-fs (dm-0): mounted filesystem with ordered data mode.
Opts: (null). Quota mode: none.
[  850.370106] ext4 filesystem being mounted at /vdc supports timestamps until
2038 (0x7fffffff)
[  850.479981] EXT4-fs (dm-0): mounted filesystem with ordered data mode.
Opts: (null). Quota mode: none.
[  850.480782] ext4 filesystem being mounted at /vdc supports timestamps until
2038 (0x7fffffff)
[  850.530734] BUG: kernel NULL pointer dereference, address: 0000000000000058
[  850.531241] #PF: supervisor read access in kernel mode
[  850.531613] #PF: error_code(0x0000) - not-present page
[  850.532020] PGD 2a496067 P4D 2a496067 PUD 0 
[  850.532336] Oops: 0000 [#1] SMP NOPTI
[  850.532604] CPU: 1 PID: 19542 Comm: dmsetup Not tainted 5.11.0-rc2-xfstests
#8
[  850.533156] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.14.0-1.fc33 04/01/2014
[  850.533780] RIP: 0010:thaw_bdev+0x47/0x90
[  850.534106] Code: 8b 83 d8 04 00 00 85 c0 74 57 83 e8 01 45 31 e4 85 c0 89
83 d8 04 00 00 7f 2d 48 8b bb 80 05 00 007
[  850.535447] RSP: 0018:ffffb97586c2bcd8 EFLAGS: 00010286
[  850.535822] RAX: 0000000000000000 RBX: ffff9df4a2e74240 RCX:
ffffb97586c2bbdc
[  850.536361] RDX: ffff9df4fdc17e80 RSI: ffff9df4a2e74790 RDI:
ffff9df48b0bf000
[  850.536864] RBP: ffff9df4a2e74720 R08: 0000000000000000 R09:
0000000000040216
[  850.537410] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  850.537950] R13: 0000000000000000 R14: 0000000000000006 R15:
0000000000000001
[  850.538455] FS:  0000000000000000(0000) GS:ffff9df4fdc00000(0063)
knlGS:00000000f7a487c0
[  850.539063] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  850.539474] CR2: 0000000000000058 CR3: 00000000072ec002 CR4:
0000000000770ee0
[  850.540017] PKRU: 55555554
[  850.540215] Call Trace:
[  850.540395]  __dm_resume+0x70/0x90
[  850.540649]  dm_resume+0x10d/0x120
[  850.540934]  do_resume+0x17b/0x210
[  850.541182]  ctl_ioctl+0x163/0x260
[  850.541428]  ? dev_set_geometry+0x180/0x180
[  850.541730]  dm_compat_ctl_ioctl+0xc/0x10
[  850.542056]  __do_compat_sys_ioctl+0x137/0x160
[  850.542375]  __do_fast_syscall_32+0x5c/0x90
[  850.542682]  do_fast_syscall_32+0x2f/0x70
[  850.543007]  entry_SYSENTER_compat_after_hwframe+0x4d/0x5f
[  850.543404] RIP: 0023:0xf7f05549
[  850.543640] Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8
01 00 00 00 00 00 00 00 00 00 00 00 00 000
[  850.545029] RSP: 002b:00000000ffaed778 EFLAGS: 00000296 ORIG_RAX:
0000000000000036
[  850.545566] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
00000000c138fd06
[  850.546107] RDX: 00000000573ca4f0 RSI: 00000000f7eea266 RDI:
00000000f7eea266
[  850.546613] RBP: 00000000ffaed828 R08: 0000000000000000 R09:
0000000000000000
[  850.547154] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  850.547651] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[  850.548191] CR2: 0000000000000058
[  850.548431] ---[ end trace ec81eda86d2573e7 ]---
[  850.548761] RIP: 0010:thaw_bdev+0x47/0x90
[  850.549089] Code: 8b 83 d8 04 00 00 85 c0 74 57 83 e8 01 45 31 e4 85 c0 89
83 d8 04 00 00 7f 2d 48 8b bb 80 05 00 007
[  850.550444] RSP: 0018:ffffb97586c2bcd8 EFLAGS: 00010286
[  850.550816] RAX: 0000000000000000 RBX: ffff9df4a2e74240 RCX:
ffffb97586c2bbdc
[  850.551359] RDX: ffff9df4fdc17e80 RSI: ffff9df4a2e74790 RDI:
ffff9df48b0bf000
[  850.551863] RBP: ffff9df4a2e74720 R08: 0000000000000000 R09:
0000000000040216
[  850.552405] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  850.552944] R13: 0000000000000000 R14: 0000000000000006 R15:
0000000000000001
[  850.553450] FS:  0000000000000000(0000) GS:ffff9df4fdc00000(0063)
knlGS:00000000f7a487c0
[  850.554060] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  850.554466] CR2: 0000000000000058 CR3: 00000000072ec002 CR4:
0000000000770ee0
[  850.555008] PKRU: 55555554
[  850.555206] BUG: sleeping function called from invalid context at
include/linux/percpu-rwsem.h:49
[  850.555833] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 19542,
name: dmsetup
[  850.556436] INFO: lockdep is turned off.
[  850.556718] irq event stamp: 8602
[  850.556997] hardirqs last  enabled at (8601): [<ffffffff95cd4ed6>]
queue_work_on+0x56/0x70
[  850.557588] hardirqs last disabled at (8602): [<ffffffff969453c5>]
exc_page_fault+0x35/0x240
[  850.558220] softirqs last  enabled at (8568): [<ffffffff964a651a>]
__rhashtable_insert_fast.constprop.0+0x2ca/0x540
[  850.558997] softirqs last disabled at (8566): [<ffffffff964a6317>]
__rhashtable_insert_fast.constprop.0+0xc7/0x540
[  850.559729] CPU: 1 PID: 19542 Comm: dmsetup Tainted: G      D          
5.11.0-rc2-xfstests #8
[  850.560373] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.14.0-1.fc33 04/01/2014
[  850.561030] Call Trace:
[  850.561211]  dump_stack+0x77/0x97
[  850.561454]  ___might_sleep.cold+0xa6/0xb6
[  850.561753]  exit_signals+0x1c/0x2c0
[  850.562048]  do_exit+0xb4/0x3d0
[  850.562278]  rewind_stack_do_exit+0x17/0x20
[  850.562578] RIP: 0023:0xf7f05549
[  850.562818] Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8
01 00 00 00 00 00 00 00 00 00 00 00 00 000
[  850.564185] RSP: 002b:00000000ffaed778 EFLAGS: 00000296 ORIG_RAX:
0000000000000036
[  850.564716] RAX: ffffffffffffffda RBX: 0000000000000003 RCX:
00000000c138fd06
[  850.565248] RDX: 00000000573ca4f0 RSI: 00000000f7eea266 RDI:
00000000f7eea266
[  850.565747] RBP: 00000000ffaed828 R08: 0000000000000000 R09:
0000000000000000
[  850.566280] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000000
[  850.566779] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000

Ciao
Stephan
> 
> - Eric


