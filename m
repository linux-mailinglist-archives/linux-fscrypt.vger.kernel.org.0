Return-Path: <linux-fscrypt+bounces-609-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B487A38B67
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 19:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 483093ADABB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 18:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D66AA23645D;
	Mon, 17 Feb 2025 18:43:29 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158F8188A3B;
	Mon, 17 Feb 2025 18:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739817809; cv=none; b=lZC4yY4Cfewei7YQ6LvPYV08CHxIHkj3Lok3vF0Noggz/ya4bEp6Xenytodne2X6b9slCcVIUZGY/hEkKnoAStwohKp1R2O6C79SWxBbyHJxN+WGWIMTWnQ+5NZYkUT6NLCozn4oTz4HRtRlCHKariqCAln/Q3OJH8z8ZSMZ1M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739817809; c=relaxed/simple;
	bh=RUgkl8+qiiUJqMZDSidbtp6rukdJhBWi9YsrZQib35w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kd6KzreW8vbax0gu2frR7VDyDM+8LXUdDkDFF89sXEmBcQDVsuAW0gByCyIrJpimLEn+p15UfMVuOlvmKEcaeOTigO52UfSqT7ySPAfkA6UY2y/oj9X4wHWdTvREQ128USStGG+jdCtGh0BSxlge7+oRmWplsHlRHbM1oWITeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6fb3a611afdso30948817b3.0;
        Mon, 17 Feb 2025 10:43:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739817807; x=1740422607;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PFc6FgN8m4J2TWKi8vdlYPk5a0hg89Z1mc2OwblTl34=;
        b=gbMMu0skd/lWQcbgtLBlZZEP2qIFatvbX3AXZ3eyogj/gzuQi9Os6uuTzrOncaNTUQ
         T0aZgy4kosVR4ChLawkDn78XAJuNO3H/Q8GIktCKZXSlpb3zR6OXiILVcBel/NMT5T7S
         QBBg0s5LDcE6H3ywb+Xku0faozxFOGnzpG4SL1BqKjrGT8s8F8b7ezGDYeK88fB3nEPA
         /4qtN/EM5hbGvPOdwk8v//WR2FlUrFB4y5kOGUVn3qvfAPt/M5nDmJKu8EMrs0ienLgP
         fMrCnrO9ufjpa7xQosbnY7hjOQSY/RXixyetoMc6fsiXYbul2LtJ7EIoToyB/ANesWfm
         KXGQ==
X-Forwarded-Encrypted: i=1; AJvYcCURc5lKXQaeDuVb5JyYZgtQwK9v9dKEeWTkVG0txD6k+uc2hqhOGOdctNMOmzIlriHMqUMPd5zn+sDGvn5L@vger.kernel.org, AJvYcCXYwHu0CUHW8j+PVUJHckmjvv6LbKrqdWyRsiwjd7+mGX6YUc67G6Gkf9pty40my/Ahy4QjgKXnHW+TE92MfA==@vger.kernel.org, AJvYcCXzaE8/wQXywp8iyNhshTq5aCcP1Htw+3oRSqKhiki+H34x8F2YNx6QNDQx9WmJd4jXbTgTZXxQzoVwL10=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0UePy/f8n82y1bHWiI9vdW408Efl/KlKMbN86O6S9qJrBVqYU
	4HMX2cmZJf2RfbE3dmJqG/48A5FKY6M8QNMfDxZ0usIX341AQLKY/qkV+gjK
X-Gm-Gg: ASbGncunxQVT4xED1ThF0n7+RP+XxUuY7G1v/W6Hi9a2cCQdnvXFECXoEMd1VI7+KP6
	FsOiSrFsI5Dd4fzvq3KEwxveDjV8+uhuIre54Ok0+k9NnATNSPHF58G85Ef9fZBMY65qkgOBM8U
	djZqVMxWLLuKwyaoPcBC0fMlE1CS6TU0nVHPUO1jtclSkhUWQ40gETZeJQRF2aQL+xN+EiBeURC
	WOhIdS8/MTtaSJuSKJVct7gGRKkKQp765+CnRhFwrWmFuo89kO+gDM70K7f+C1FFbo2HkyU3bOo
	pfwwlOieWipUbgDi5x7CtYLsiqdXQccWbfreRUKi8570a+cUa+WB
X-Google-Smtp-Source: AGHT+IFDW2YQz9xie7jp11jQsm49Vx5YDGdLya1FoWyEe161ZR/tmEfYh+OINbggTTULDGCAq8rCPQ==
X-Received: by 2002:a05:690c:4c0a:b0:6f9:b189:3cc7 with SMTP id 00721157ae682-6fb582b757emr87012937b3.18.1739817806773;
        Mon, 17 Feb 2025 10:43:26 -0800 (PST)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fb7ca441e0sm5968497b3.100.2025.02.17.10.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 10:43:26 -0800 (PST)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6ef7c9e9592so35457747b3.1;
        Mon, 17 Feb 2025 10:43:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUaMNq+YdlRUvU7EotQ03CBRTHexY4wu3+XJ0aY8+krIzMAL0Le2MJY6p+mzps2Wbmz2Pm5mv9rUvHGlDY=@vger.kernel.org, AJvYcCVNPRCAuGtSYhrzdQebmSfG6t44n12wbFSzYIWq2kn2Unh1HJGKf7NyvH+R3AJijmDQ96HFFRgmFeliD/Wf@vger.kernel.org, AJvYcCXDPSRAgTCQS+W3oHpRlzT3TSZMbc+HLFIf3H1Vukr+6E5yAAoEUtwpIp7BgxV0fBHUTXo+IasBktl9fGqk/g==@vger.kernel.org
X-Received: by 2002:a05:690c:9217:b0:6fb:91a9:94d9 with SMTP id
 00721157ae682-6fb91a9969emr5116087b3.2.1739817806159; Mon, 17 Feb 2025
 10:43:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Reply-To: tanure@linux.com
From: Lucas Tanure <tanure@linux.com>
Date: Mon, 17 Feb 2025 18:43:15 +0000
X-Gmail-Original-Message-ID: <CAJX_Q+24svAcoyxqcUu4z2g08bJeRFEmzYtVK1paoZ0xBX_uTA@mail.gmail.com>
X-Gm-Features: AWEUYZl_7IlOgzFB-KpkD13HgqA2BIMZysbWNtof4L3UoLqK50-0X4pW8xCZseE
Message-ID: <CAJX_Q+24svAcoyxqcUu4z2g08bJeRFEmzYtVK1paoZ0xBX_uTA@mail.gmail.com>
Subject: crypto: fscrypt: crypto_create_tfm_node memory leak
To: kernelnewbies <kernelnewbies@kernelnewbies.org>, linux-fscrypt@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Cc: "krzysztof.opasiak@neat.no" <krzysztof.opasiak@neat.no>, 
	"lucas.tanure@neat.no" <lucas.tanure@neat.no>
Content-Type: text/plain; charset="UTF-8"

Hi,

I am working with Android 13 and V5.15 kernel. During our development,
I found a memory leak using kmemleak.

Steps I did to find the memleak:
mount -t debugfs debugfs /sys/kernel/debug
echo scan=5 > /sys/kernel/debug/kmemleak
cat /sys/kernel/debug/kmemleak

Stack I got (hundreds of them):
unreferenced object 0xffffff8101d31000 (size 1024):
  comm "binder:1357_2", pid 1357, jiffies 4294899464 (age 394.468s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffd327cac060>] crypto_create_tfm_node+0x64/0x228
    [<ffffffd3279f8c4c>] fscrypt_prepare_key+0xbc/0x230
    [<ffffffd3279f9758>] fscrypt_setup_v1_file_key+0x48c/0x510
    [<ffffffd3279f8394>] fscrypt_setup_encryption_info+0x210/0x43c
    [<ffffffd3279f8108>] fscrypt_prepare_new_inode+0x128/0x1a4
    [<ffffffd327bcc878>] f2fs_new_inode+0x27c/0x89c
    [<ffffffd327bce7c4>] f2fs_mkdir+0x78/0x278
    [<ffffffd32796a3bc>] vfs_mkdir+0x138/0x204
    [<ffffffd32796a108>] do_mkdirat+0x88/0x204
    [<ffffffd32796a068>] __arm64_sys_mkdirat+0x40/0x58
    [<ffffffd3274be5d4>] invoke_syscall+0x60/0x150
    [<ffffffd3274be528>] el0_svc_common+0xc8/0x114
    [<ffffffd3274be3f0>] do_el0_svc+0x28/0x98
    [<ffffffd328abcf88>] el0_svc+0x28/0x90
    [<ffffffd328abcefc>] el0t_64_sync_handler+0x88/0xec
    [<ffffffd32741164c>] el0t_64_sync+0x1b8/0x1bc

After checking upstream, I came up with the following:
cff805b1518f  fscrypt: fix keyring memory leak on mount failure

But my kernel has this patch. So I continued to dig around this and
saw the function fscrypt_prepare_key in fs/crypto/keysetup.c for
V5.15.
I can't see the pointer tfm being used anywhere or saved, and
smp_store_release doesn't kfree it.
Is smp_store_release doing something with that pointer that makes this
memory leak a false positive?

Any help with this issue would be much appreciated.
Thanks

Lucas Tanure

