Return-Path: <linux-fscrypt+bounces-28-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D4267F4861
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 14:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A94DB20C75
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 13:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEFE1F615;
	Wed, 22 Nov 2023 13:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="JF3t06jG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981E1101
	for <linux-fscrypt@vger.kernel.org>; Wed, 22 Nov 2023 05:58:39 -0800 (PST)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-5c85e8fdd2dso53951747b3.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 22 Nov 2023 05:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1700661519; x=1701266319; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SIaRnMCnFf33Dk0CGq5Vom1OCMuvBN6qt1lqDDImBdk=;
        b=JF3t06jG0uz3NeOiVBtE/rTDuXfFbSc9ki7R/QMRlG2O8CF7iZ6ZVrstPXS9LyTwhZ
         Kj43FTx17WDhXRDOcKVMhDSHJ0VV/gVDfwo1ZrpwKoO0+sXtvh1zGaZK07eBBlS1mS0g
         nvRM20iH1puEy1Qn2KYfAWsncNX2y0V8wv2HV7dfDxvySArlbZzrRaFS1Dxfhdot0Kme
         i7v4AfDuDb1FbD+cbf4sRbO5o0V1qca0ChPesyEVa/yG+BpwI/mwe8RpPjg3Oivuk+ep
         TLXTdHN5565StgWGT1QwWmJx4BlP8dQdojwsWXcmOphUzRa3k8re5Sk222a8jcGc8f8e
         CnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700661519; x=1701266319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIaRnMCnFf33Dk0CGq5Vom1OCMuvBN6qt1lqDDImBdk=;
        b=S63pJ8hqOJQdW/IVkXgdEhYm+dmh1+FJU4pXse9P3MEZzLyke2I/3Mk2opOp35c6ef
         tB4DvSEQg9Vrm95v+THdvimQle5TEBOVaEfvcXg8rI+w6/xZkdzvuzD7mmNLsr96lKvb
         IHVW7ReqkzC99t2SLTlPEUUKqZ9lihgaGDNn+NOpqVQq/TWfusZ6WEVpeAQwakCRvGyK
         bcV5nfKqd0bJ77+ylKgDwtHN8BCXtAWITfqurGkkX/qM5Hy1ma30gDSTHcnUL8vQDvtq
         JXjd+N7L+irTuOCm37G+95FMJOerlNi8kdEz51KdFSYZIK81XrAL/aTPsfSH8/+SddJl
         UsaQ==
X-Gm-Message-State: AOJu0YygPOAF7E7Hr/gjv9xYyhMTUMGeHtBWwHlJirZcrhvt3ZZkaZVm
	GBJIESoUfQAFIiPFPxX8mZLh3g==
X-Google-Smtp-Source: AGHT+IG6W7SD0/Yp3CzRBpKKcOt7lXganat9ICWBIYIFBoEubf9tkmKa200gR3a7sqO3BfjUMZx2IA==
X-Received: by 2002:a0d:d547:0:b0:5b3:26e1:320c with SMTP id x68-20020a0dd547000000b005b326e1320cmr2299541ywd.40.1700661518764;
        Wed, 22 Nov 2023 05:58:38 -0800 (PST)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id w67-20020a816246000000b005a7aef2c1c3sm3728854ywb.132.2023.11.22.05.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 05:58:38 -0800 (PST)
Date: Wed, 22 Nov 2023 08:58:37 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/36] btrfs: add fscrypt support
Message-ID: <20231122135837.GA1733890@perftesting>
References: <cover.1696970227.git.josef@toxicpanda.com>
 <20231121230232.GC2172@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121230232.GC2172@sol.localdomain>

On Tue, Nov 21, 2023 at 03:02:32PM -0800, Eric Biggers wrote:
> On Tue, Oct 10, 2023 at 04:40:15PM -0400, Josef Bacik wrote:
> > Hello,
> > 
> > This is the next version of the fscrypt support.  It is based on a combination
> > of Sterba's for-next branch and the fscrypt for-next branch.  The fscrypt stuff
> > should apply cleanly to the fscrypt for-next, but it won't apply cleanly to our
> > btrfs for-next branch.  I did this in case Eric wants to go ahead and merge the
> > fscrypt side, then we can figure out what to do on the btrfs side.
> > 
> > v1 was posted here
> > 
> > https://lore.kernel.org/linux-btrfs/cover.1695750478.git.josef@toxicpanda.com/
> 
> Hi Josef!  Are you planning to send out an updated version of this soon?
> 

Hey Eric,

Yup I meant to have another one out the door a couple of weeks ago but I was
going through your fstests comments and learned about -o test_dummy_encryption
so I implemented that and a few problems fell out, and then I was at Plumbers
and Maintainers Summit.  I'm working through my mount api changes now and the
encryption thing is next, I hope to get it out today as I fixed most of the
problems, I just have to fix one of our IOCTL's that exposes file names that
wasn't decrypting the names and then hopefully it'll be good.

FWIW all the things I had to fix didn't require changes to the fscrypt side, so
it's mostly untouched since last time.  Thanks,

Josef

