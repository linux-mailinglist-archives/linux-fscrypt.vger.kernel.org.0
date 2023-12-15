Return-Path: <linux-fscrypt+bounces-88-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A59E9814A70
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Dec 2023 15:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B8391F251F3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Dec 2023 14:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36B231A6C;
	Fri, 15 Dec 2023 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="fsH9Fsk+"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF431A6B
	for <linux-fscrypt@vger.kernel.org>; Fri, 15 Dec 2023 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-5e2bd289172so6313457b3.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Dec 2023 06:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1702650392; x=1703255192; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+4V/xtuU5RtW7auv55nECI5YJaBifIHvReIdoO950Ik=;
        b=fsH9Fsk+hk7UK5xelpzTDhf5qmKjvpAZPUx1iXrFy36UHS/i+FyVliO8ZiK7Bnuv3p
         bgvDGF0P6UVVryG1F/tcbB29gUoDjTWl6/AvPUMDxV18bfXrdEjhY+iX6e+qN2NH33Je
         VVjopa6B+3wW3eegOGIhbAyVvIyM35KyY7JBrV6jykv6ZTV8cohDxee+uq6tG+3Ryndv
         z6O3MbJa4faLHIxdSG0Jp7e60zqbnMP1CJ1RSNxp1TB0Y7KD3RMThNId69csBgew3jM0
         /UtFD22qUqm1jozA77C2TEN1uM4HSuhewNEBcGNfCsgjWeK7QVwaITyQzX+2/Fxwd/I/
         X07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702650392; x=1703255192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4V/xtuU5RtW7auv55nECI5YJaBifIHvReIdoO950Ik=;
        b=ANRjKCnWO/m/A44rR6sTXC888gPVYsQ2T62SP+vLfWZBWdGiDO+nwzSEHUMNcSChW0
         wSRyNsriub2kR/Qc8BzUtH6ISCB5/Ju3v0L1M6iVvVRKQjxJfOJPevWDm0OIlWs17Wyl
         ibu9fIm63pzjjM4yKrlHTbq1807fopbgOaN7dAKrUV2dMEg265dQcNN7Zsh+jo5PcFgy
         +Xk0hPO97FcsNCaumkMoP+30ZyLhbb9aoK/TcbyhhMqD3xk2kWh/ykYwwWq52MKj2NMY
         auMyaiKK2fxuX3XXChOcplTrX16eCdp+xZazJDy59sPrMVJNZJZlPw10f5Xc4dSGAJjw
         7yhg==
X-Gm-Message-State: AOJu0YxmQZUE4MiZOsJaXoBDNUse7WYPaCx+5K/SGJZ2gVdkl1KCD2np
	QaROSTq2IqtSC8kkztzUzHbuAQ==
X-Google-Smtp-Source: AGHT+IGpj2fZ4DlpWbI9o2AbVXyl3n081P7woEHQN+l8wabNi4vE8R5e3ZFfwi7WbmH7RL0B6LtbAw==
X-Received: by 2002:a0d:d812:0:b0:5e3:347b:e864 with SMTP id a18-20020a0dd812000000b005e3347be864mr3181497ywe.26.1702650392430;
        Fri, 15 Dec 2023 06:26:32 -0800 (PST)
Received: from localhost (076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id x8-20020a814a08000000b005d3b4fce438sm6269510ywa.65.2023.12.15.06.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 06:26:31 -0800 (PST)
Date: Fri, 15 Dec 2023 09:26:30 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 1/3] btrfs: call btrfs_close_devices from ->kill_sb
Message-ID: <20231215142630.GB683314@perftesting>
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
> 

Yup, sorry Christoph I missed this email when you sent it, I'll throw it in
there now.  Thanks,

Josef

