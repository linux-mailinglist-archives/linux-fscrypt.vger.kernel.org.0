Return-Path: <linux-fscrypt+bounces-612-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9F2A38C01
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 20:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 642C618874E1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 19:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9352C236A6A;
	Mon, 17 Feb 2025 19:08:39 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3726236455;
	Mon, 17 Feb 2025 19:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739819319; cv=none; b=nqCbBrPvUOkOcrNbZ3Y8x/Bf66yhJruaa+nUjUlfFU/qGyfU+P090j6KmbSj9OWmoKLNaNR5TprRurWi+p01c8oKwJGYcY5oQM/vMkfUN6IdgYQdwaJBm/KfOa9DO0zGby/IOLTv0NbLCO9AgJUvIYfKp9Wtg8pzfc19ALkbpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739819319; c=relaxed/simple;
	bh=WgkdyXz/h4gUCs6OL7rS7szH6rN+Xn9RvUn4fwT9GNc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DDGA4OIVoD5mnUkYLNHXEOsLGHMxFN4JWId5BSj/OcNg/kAUM9UMMK3Fs/fL9lLhvkRHdIWe/0naoXlFYFw8iU4q8+hKAzUu2FA/mZ3oQnfz1/Gwz9JRgLXfUtUrxjzCqwEEgMFKyEwWSW9GyzgWlIJ1Ga4MKl6NZA0dlGI6qnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6f4434b5305so39354397b3.3;
        Mon, 17 Feb 2025 11:08:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739819316; x=1740424116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZoHEtc6NLvxTZfVznB+yP1hpkpOf050NiXXR/iSxdxA=;
        b=EvZCJr8iJHe02s3pVS3aMPnd+VfTVs6sZQFaeLgseY4gtLtdEm0HhHGuxysrNAaZvG
         NPPnFP8DFy4i2Y7n9EU32SMmCvAqx6e/birUUxE/ykwfvz1bpWqRLVKfSyVWLd3nz4rs
         64GGwUIQ9ptVSo6zSU2iMeTnisqL6xgy04E5i4kzZmkqwiIqOmeMuD/O7eFVDvbhrRL2
         lofz/42yXr9YHuTvSxqn8dJBrgfDVFIqK6RFsNgmOtYe4wUuLzMhvGqd6pK7QHwr5G3g
         qbeUfBuRTJ28G/te3PNZMsXVf24asfke25RDQQOoqi56fJdTBf43kmS6w8AuWnHWXYYb
         ayKw==
X-Forwarded-Encrypted: i=1; AJvYcCUzr01blnx1hxMrjUqP4T225/tizdt/ql7Nq+OXOilxA6GG9ygZeun/mR3/0Pn/X1zwbYVsb96qe715dMarrw==@vger.kernel.org, AJvYcCVvLymNt8V5e1OUH4aOsEw6ifSQb9IE+EibDqyCW71sTvqZ2AXFS5m7pFg1WIburSwU9tqNTmK9M09a1zmc@vger.kernel.org, AJvYcCXgUPZ5V/kp2lmMRHYzPkr18L8a6DHRQNi+xzbgDNyYYdh4xjXLl8/65oe0lbnoobPFp7vnXMA6qy9MVAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq+a7xEN5wMbe5JdoPoTeMN1HevarpW/cUzxDkKxQIBBvO419r
	MucvyRLu4VIxEat3uqKdJigtydGX7momo/s9vKZNGPu79u7nKJoz4y3HvEZY
X-Gm-Gg: ASbGncuOzZSqmOtzS+FHQjYrCISu+upsTbcB/2Gy2IxTqY5FKPTXH8GruXLcJK780PP
	YlHHGWaIDlfGx42SFX0bsbrtR0JeNwM+EJiv1G8sZ6DbWOJnAU5ZUl3Y/38Yh+RD/G2GmXu+80V
	UQGDFxXkl/EzO0LyaA6nJmKO6Wa2JPGtzC0VL4OwHKzcNvDE/QLRGd8w36VgtcoFKqbRIsr2AAu
	0vp+TryHhDNTsaiNK+PP4TdQIN3CzM4XEr6V8LYfQGbwcvdGhg3LbzyeYT8g+ApLWDy/EcveJnw
	DE4S09HCKG+GWAMQ5sbadgqgHBa9U6vN+4OWT9+rumLcVKVhMkeV
X-Google-Smtp-Source: AGHT+IG6FXg6nyc9zZN0uC1B+Z/cHzImnKCD8NnkHwBMHcnUcgpPESezlr8k0uSDDllYsmBZBmQPzA==
X-Received: by 2002:a05:690c:4d89:b0:6f2:9533:8fba with SMTP id 00721157ae682-6fb5827084bmr96730387b3.1.1739819316564;
        Mon, 17 Feb 2025 11:08:36 -0800 (PST)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com. [209.85.128.170])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fb361bce8bsm22315607b3.104.2025.02.17.11.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 11:08:36 -0800 (PST)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6f4434b5305so39354197b3.3;
        Mon, 17 Feb 2025 11:08:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVQDEH4UY9riHIPaks2l48c3cUHA4GrqGyrzncTNWV7tTpnUn7ZoRtQbkX6B/YxEpwmiLzv6NdrTrAxLWRbaA==@vger.kernel.org, AJvYcCWtnvSihLFP9P1TieP3YTqDypbjnIuUULRupkLQlevtVcvK/uMoCNpRJqsW4+hqpXaxyEhEynGEKWkb8hw=@vger.kernel.org, AJvYcCXG0RytHiN7HpP1qMlZZTMAgaf0pw6ovhuAN+nqYn8MSAxQ4u6eYNt6e9fvbjYMTUS9hIBn1OKGxhXsV66S@vger.kernel.org
X-Received: by 2002:a05:690c:4c0a:b0:6f9:b189:3cc7 with SMTP id
 00721157ae682-6fb582b757emr87826527b3.18.1739819315947; Mon, 17 Feb 2025
 11:08:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJX_Q+24svAcoyxqcUu4z2g08bJeRFEmzYtVK1paoZ0xBX_uTA@mail.gmail.com>
 <20250217185000.GC1258@sol.localdomain>
In-Reply-To: <20250217185000.GC1258@sol.localdomain>
Reply-To: tanure@linux.com
From: Lucas Tanure <tanure@linux.com>
Date: Mon, 17 Feb 2025 19:08:25 +0000
X-Gmail-Original-Message-ID: <CAJX_Q+3Cp=5WVxACFCuYDfUzndVfeewykYbxSw1f4zyKm0DvsA@mail.gmail.com>
X-Gm-Features: AWEUYZmizRkxC2vzDxy52kCc9Y20ryP3d4RTkB0b2ddqian4SMSNyTSuh2X7VX8
Message-ID: <CAJX_Q+3Cp=5WVxACFCuYDfUzndVfeewykYbxSw1f4zyKm0DvsA@mail.gmail.com>
Subject: Re: crypto: fscrypt: crypto_create_tfm_node memory leak
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>, linux-fscrypt@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, 
	"krzysztof.opasiak@neat.no" <krzysztof.opasiak@neat.no>, "lucas.tanure@neat.no" <lucas.tanure@neat.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 6:50=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Feb 17, 2025 at 06:43:15PM +0000, Lucas Tanure wrote:
> > Hi,
> >
> > I am working with Android 13 and V5.15 kernel. During our development,
> > I found a memory leak using kmemleak.
> >
> > Steps I did to find the memleak:
> > mount -t debugfs debugfs /sys/kernel/debug
> > echo scan=3D5 > /sys/kernel/debug/kmemleak
> > cat /sys/kernel/debug/kmemleak
> >
> > Stack I got (hundreds of them):
> > unreferenced object 0xffffff8101d31000 (size 1024):
> >   comm "binder:1357_2", pid 1357, jiffies 4294899464 (age 394.468s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffd327cac060>] crypto_create_tfm_node+0x64/0x228
> >     [<ffffffd3279f8c4c>] fscrypt_prepare_key+0xbc/0x230
> >     [<ffffffd3279f9758>] fscrypt_setup_v1_file_key+0x48c/0x510
> >     [<ffffffd3279f8394>] fscrypt_setup_encryption_info+0x210/0x43c
> >     [<ffffffd3279f8108>] fscrypt_prepare_new_inode+0x128/0x1a4
> >     [<ffffffd327bcc878>] f2fs_new_inode+0x27c/0x89c
> >     [<ffffffd327bce7c4>] f2fs_mkdir+0x78/0x278
> >     [<ffffffd32796a3bc>] vfs_mkdir+0x138/0x204
> >     [<ffffffd32796a108>] do_mkdirat+0x88/0x204
> >     [<ffffffd32796a068>] __arm64_sys_mkdirat+0x40/0x58
> >     [<ffffffd3274be5d4>] invoke_syscall+0x60/0x150
> >     [<ffffffd3274be528>] el0_svc_common+0xc8/0x114
> >     [<ffffffd3274be3f0>] do_el0_svc+0x28/0x98
> >     [<ffffffd328abcf88>] el0_svc+0x28/0x90
> >     [<ffffffd328abcefc>] el0t_64_sync_handler+0x88/0xec
> >     [<ffffffd32741164c>] el0t_64_sync+0x1b8/0x1bc
> >
> > After checking upstream, I came up with the following:
> > cff805b1518f  fscrypt: fix keyring memory leak on mount failure
> >
> > But my kernel has this patch. So I continued to dig around this and
> > saw the function fscrypt_prepare_key in fs/crypto/keysetup.c for
> > V5.15.
> > I can't see the pointer tfm being used anywhere or saved, and
> > smp_store_release doesn't kfree it.
> > Is smp_store_release doing something with that pointer that makes this
> > memory leak a false positive?
> >
> > Any help with this issue would be much appreciated.
> > Thanks
>
> The pointer to the crypto_skcipher 'tfm' is stored in the fscrypt_inode_i=
nfo
> (previously fscrypt_info) which is stored in inode::i_crypt_info.  It get=
s freed
> when the inode is evicted.  I don't know why you're getting a kmemleak wa=
rning.
> Perhaps f2fs in that version of the kernel has a bug that is leaking inod=
es.
>
Thanks. How do you check for leaking inodes? Do you have any start
point (function) to look at?

> smp_store_release is just a fancy way of doing a store that includes a me=
mory
> barrier.
>
> - Eric

Lucas

