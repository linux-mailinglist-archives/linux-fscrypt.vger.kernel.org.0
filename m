Return-Path: <linux-fscrypt+bounces-89-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 125DC815208
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Dec 2023 22:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 449001C21412
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Dec 2023 21:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2D649F6F;
	Fri, 15 Dec 2023 21:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="qlpswb1D"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E486949F70
	for <linux-fscrypt@vger.kernel.org>; Fri, 15 Dec 2023 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-5d7a47d06eeso10916897b3.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Dec 2023 13:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1702676752; x=1703281552; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Voo/Qo5neoICI5TEYLgUqQlKmAzhYFSB0CPj59btfKQ=;
        b=qlpswb1DLMhzlDsKOBNvP0yThjdBFWhR2ne/ZU7HPq2/8b9pfZt5oEVHVuc7RkeMuF
         EVOFx42ECpSBoj173PiPwUji9255AqY5xRcu+HDdqp6bU2udyUbkKLHZn3R2xmrnHQrL
         DP1vdtuyL0zdyHalAvw7jpIzazS2dJ7B/f5ww8ieDYCDUp0Zvxqdet+XtLnAb/Li6sDj
         Yf1TEKbH3ey/4FQ1QBFlZoBlGJ6upflHh1bj8HpIBME/DActXx6g5wBA7YntCdEsWn3u
         Oj/8KSGWA7tr0ivpMQvYL5n1HCxiSMGywlBIOh4BfneCYoA/hfUrYaS/FgY5LF+BueQp
         N3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702676752; x=1703281552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Voo/Qo5neoICI5TEYLgUqQlKmAzhYFSB0CPj59btfKQ=;
        b=DzFdz+QAfHWNF6JlwGf/e3wmiaskwhzKyykb6HZyVKddvyN/16zyGbU+0drQar+QTf
         tF5nGwUpg3dMG/M1fhF4ibncEiXEfgfFJ/hoY2EIBR4LBswB0CWOUew+NmvBcOMdlRbV
         Yl1al0hyC0kLVyLc7iQPCdKvG7IaqPHvCqBrBGq4RVdiHEDgHYQf4Q/goPpJXTgXjtKc
         htefVA2uRP1wvgKwm3XIdFA0kNe+SoNSDOA+ytAsV25OieIGGqyjdM2Ul2dS05fPjvJe
         2kSnw5kNtJUi8JZzIPPZ8YmEhs06Cl8wCcPn9qdWdM/x69oDcGTXHGKafo8yK1c6t85l
         JkXA==
X-Gm-Message-State: AOJu0YyAvvmrLmR4/SLfSh1iyk04gm18BkT9LFk/SJ6wtPcAsDk5m/Mq
	VWYOi+qQBKNu4nZROD8HGErELjCWzToBbH/1PFc=
X-Google-Smtp-Source: AGHT+IGn2gXyZ44rH0GdttHxI9BDGa6muaa1HTZ9b5XYSMgUKOgwNkucKhJf+BqCcDPHEJOxXfTXxQ==
X-Received: by 2002:a0d:d9cc:0:b0:5e3:3bcc:c344 with SMTP id b195-20020a0dd9cc000000b005e33bccc344mr3671813ywe.33.1702676751819;
        Fri, 15 Dec 2023 13:45:51 -0800 (PST)
Received: from localhost (076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id b80-20020a0dd953000000b005e2ca09e751sm2443263ywe.110.2023.12.15.13.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 13:45:50 -0800 (PST)
Date: Fri, 15 Dec 2023 16:45:50 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH 1/3] btrfs: call btrfs_close_devices from
 ->kill_sb
Message-ID: <20231215214550.GB883762@perftesting>
References: <20231213040018.73803-1-ebiggers@kernel.org>
 <20231213040018.73803-2-ebiggers@kernel.org>
 <20231213084123.GA6184@lst.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213084123.GA6184@lst.de>

On Wed, Dec 13, 2023 at 09:41:23AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 12, 2023 at 08:00:16PM -0800, Eric Biggers wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > blkdev_put must not be called under sb->s_umount to avoid a lock order
> > reversal with disk->open_mutex once call backs from block devices to
> > the file system using the holder ops are supported.  Move the call
> > to btrfs_close_devices into btrfs_free_fs_info so that it is closed
> > from ->kill_sb (which is also called from the mount failure handling
> > path unlike ->put_super) as well as when an fs_info is freed because
> > an existing superblock already exists.
> 
> Thanks, this looks roughly the same to what I have locally.
> 
> I did in fact forward port everything missing from the get_super
> series yesterday, but on my test setup btrfs/142 hangs even in the
> baseline setup.  I went back to Linux before giving up for now.
> 
> Josef, any chane you could throw this branch:
> 
>     git://git.infradead.org/users/hch/misc.git btrfs-holder
> 
> into your CI setup and see if it sticks?  Except for the trivial last
> three patches this is basically what you reviewed already, although
> there was some heavy rebasing due to the mount API converison.

I ran it through, you broke a test that isn't upstream yet to test the old mount
api double mount thing that I have a test for

https://github.com/btrfs/fstests/commit/2796723e77adb0f9da1059acf13fc402467f7ac4

In this case we end up leaking a reference on the fs_devices.  If you add this
fixup to "btrfs: call btrfs_close_devices from ->kill_sb" it fixes that failure.
I'm re-running with that fixup applied, but I assume the rest is fine.  Thanks,

Josef

