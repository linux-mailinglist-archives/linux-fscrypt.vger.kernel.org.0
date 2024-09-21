Return-Path: <linux-fscrypt+bounces-458-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD12A97DF72
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Sep 2024 00:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DA952822E1
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Sep 2024 22:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3176561FCF;
	Sat, 21 Sep 2024 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u0yo62WZ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A6D1547C6
	for <linux-fscrypt@vger.kernel.org>; Sat, 21 Sep 2024 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726958032; cv=none; b=RV+eOhxL8HtnwmHWyi0yR0ad/x35+o62HBnFS9SbmUfsdUMd5f8x9NtWf40HmjivRNaM6Hl8dFXqY672S2rG9MzjxbjqqYM4FGlJZe17LZGkG2j3WToeeMcMyH2HlHpBiEiDnYwK/aD/NuG2A+q014GeK/M7plXdoVBYe/f2a80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726958032; c=relaxed/simple;
	bh=Tp0FNXrk2yEfqUnoYGkY4MsSg6rdyB04bZgqohgoAbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/QY0Enrrk/S7EZoWVF6Qf5ppIOF5DQ/R7Ib5nvtZI0BlfVD9DG1bJj4OxU1ASI8Cl7bLcvEDgoSWrD4vCgDdfaFnH4yGeWUI+dV/gG3h9wtrBA5p0XBX2UaQ+V2IgenjmwBT0vQ8jeArGC1ybe9Bum8Hqu/VtslWqAvx5WkzgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u0yo62WZ; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5356bb55224so4331107e87.0
        for <linux-fscrypt@vger.kernel.org>; Sat, 21 Sep 2024 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726958028; x=1727562828; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gX86j39e02j/mMJI41SFOhgjLK0jANOAafMy+BuLlM8=;
        b=u0yo62WZeZbfVJe0NakLs6fPSii9QhbqrN/LKg3sgscDwhDI/Dn2hzicmKFIn1Zsc5
         QL14mRlXSZ1yNWSNyDOA9+He07jIhuhxPm3U6XE8blBFoD9+qzq5rS7PcKRmF/s/O5Ho
         rG7paYgsWfRx+GQ7VHlhk3lSZ877+JUnSz6R20iBjnulFkXW/TAVWj1TPg3ftQT79dkl
         sf74VWHhHtFsJYh4bdguRnSscoIn6M6KsHwvCxwLdoXtwVEP6knHK33KPvG0w2nPHJ/X
         Pm+Pqd+HMl1Tu2GpBy668pvxDOIx7vVSP8a+3SGB7Mns4awQ2FbHTVvHIrxsGTZBXLcD
         76Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726958028; x=1727562828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gX86j39e02j/mMJI41SFOhgjLK0jANOAafMy+BuLlM8=;
        b=YRFQ6bGWFANXHlgl2DJlQRlpzmO85xoU6fO5Dev3NU1elCz6/2UlX7LGDqa+LNh99p
         4xxti5Tbkq4dGZiRCDqiC06UFAbWZujORL7hsEbwWMWSI22XezeFXFDHX7aekJeJIllD
         rOOYEWqLBMCmxrXjTdXQAUrGYXdi+KpeM/Fpm0JBM2OO2wlam2FOArc51VyqkwiE3Vc1
         aluloRwiFdB9cFOP4vT+zIobhEV2BMp/m3ydCZc90okL4CiElFYTwQzUZwrJFA8yu+iw
         RmxFCfUvfYn4Lkgoygw0kuMNDf7Q7gjJsqZGFEVI45PdniT3KDKCKs4naVZqN7gvP6Qc
         ZBwg==
X-Forwarded-Encrypted: i=1; AJvYcCWrF16ub/yb+e1l0hOzlkH0ljcxVyEusst/KxIaiQoRkLr30BQL7bleEdiqpwI4dp/vHAT3/1gBv2LN+bF5@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5OEx6KbjwNlxkHzpTzF8z4Xiohvk7WabNlozua1TzsSC3XB4h
	HFn8gf+tPpSCFLB2PmSXo+wwTSdmbPbOtC9+zFblXLh/LJmqFb89hW6vlE/cHE0=
X-Google-Smtp-Source: AGHT+IEQg2tUTFCeWCDOw+B1mlFRNoo51OtcNliubEi2LO0DCWuhnyqKCtGXKESfuGiyNwvVThuwYg==
X-Received: by 2002:a05:6512:ba4:b0:530:ba4b:f65d with SMTP id 2adb3069b0e04-536ad180176mr3632234e87.28.1726958027223;
        Sat, 21 Sep 2024 15:33:47 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536870ad17dsm2741416e87.241.2024.09.21.15.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 15:33:46 -0700 (PDT)
Date: Sun, 22 Sep 2024 01:33:44 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, 
	"bartosz.golaszewski" <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v6 09/17] soc: qcom: ice: add HWKM support to the ICE
 driver
Message-ID: <sgq72p6hkebkv6r5vsyvxsasojkhzlmwqravynpnwjkozwb7g7@6ml3vlkigxoh>
References: <66953e65-2468-43b8-9ccf-54671613c4ab@linaro.org>
 <ivibs6qqxhbikaevys3iga7s73xq6dzq3u43gwjri3lozkrblx@jxlmwe5wiq7e>
 <98cc8d71d5d9476297a54774c382030d@quicinc.com>
 <CAA8EJpp_HY+YmMCRwdteeAHnSHtjuHb=nFar60O_PwLwjk0mNA@mail.gmail.com>
 <9bd0c9356e2b471385bcb2780ff2425b@quicinc.com>
 <20240912231735.GA2211970@google.com>
 <CAA8EJpq3sjfB0BsJTs3_r_ZFzhrrpy-A=9Dx9ks2KrDNYCntdg@mail.gmail.com>
 <20240913045716.GA2292625@google.com>
 <egtwyk2rp3mtnw2ry6npq5xjfhjvtnymbxy66zevtdi7yvaav4@gcnmrmtqro4b>
 <20240921194939.GB2187@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240921194939.GB2187@quark.localdomain>

On Sat, Sep 21, 2024 at 12:49:39PM GMT, Eric Biggers wrote:
> Hi Dmitry,
> 
> On Fri, Sep 13, 2024 at 03:21:07PM +0300, Dmitry Baryshkov wrote:
> > > > > > > > Once ICE has moved to a HWKM mode, the firmware key programming
> > > > > > > currently does not support raw keys.
> > > > > > > > This support is being added for the next Qualcomm chipset in Trustzone to
> > > > > > > support both at he same time, but that will take another year or two to hit
> > > > > > > the market.
> > > > > > > > Until that time, due to TZ (firmware) limitations , the driver can only
> > > > > > > support one or the other.
> > > > > > > >
> > > > > > > > We also cannot keep moving ICE modes, due to the HWKM enablement
> > > > > > > being a one-time configurable value at boot.
> > > > > > >
> > > > > > > So the init of HWKM should be delayed until the point where the user tells if
> > > > > > > HWKM or raw keys should be used.
> > > > > >
> > > > > > Ack.
> > > > > > I'll work with Bartosz to look into moving to HWKM mode only during the first key program request
> > > > > >
> > > > >
> > > > > That would mean the driver would have to initially advertise support for both
> > > > > HW-wrapped keys and raw keys, and then it would revoke the support for one of
> > > > > them later (due to the other one being used).  However, runtime revocation of
> > > > > crypto capabilities is not supported by the blk-crypto framework
> > > > > (Documentation/block/inline-encryption.rst), and there is no clear path to
> > > > > adding such support.  Upper layers may have already checked the crypto
> > > > > capabilities and decided to use them.  It's too late to find out that the
> > > > > support was revoked in the middle of an I/O request.  Upper layer code
> > > > > (blk-crypto, fscrypt, etc.) is not prepared for this.  And even if it was, the
> > > > > best it could do is cleanly fail the I/O, which is too late as e.g. it may
> > > > > happen during background writeback and cause user data to be thrown away.
> > > > 
> > > > Can we check crypto capabilities when the user sets the key?
> > > 
> > > I think you mean when a key is programmed into a keyslot?  That happens during
> > > I/O, which is too late as I've explained above.
> > > 
> > > > Compare this to the actual HSM used to secure communication or
> > > > storage. It has certain capabilities, which can be enumerated, etc.
> > > > But then at the time the user sets the key it is perfectly normal to
> > > > return an error because HSM is out of resources. It might even have
> > > > spare key slots, but it might be not enough to be able to program the
> > > > required key (as a really crazy example, consider the HSM having at
> > > > this time a single spare DES key slot, while the user wants to program
> > > > 3DES key).
> > > 
> > > That isn't how the kernel handles inline encryption keyslots.  They are only
> > > programmed as needed for I/O.  If they are all in-use by pending I/O requests,
> > > then the kernel waits for an I/O request to finish and reprograms the keyslot it
> > > was using.  There is never an error reported due to lack of keyslots.
> > 
> > Does that mean that the I/O can be outstanding for the very long period
> > of time? Or that if the ICE hardware has just a single keyslot, but
> > there are two concurrent I/O processes using two different keys, the
> > framework will be constantly swapping the keys programmed to the HW?
> 
> Yes for both.  Of course, system designers are supposed to put in enough
> keyslots for this to not be much of a problem.
> 
> So, the "wait for a keyslot" logic in the block layer is necessary in general so
> that applications don't unnecessarily get I/O errors.  But in a properly tuned
> system this logic should be rarely executed.
> 
> And in cases where the keyslots really are a bottleneck, users can of course
> just use software encryption instead.
> 
> Note that the number of keyslots is reported in sysfs.
> 
> > I think it might be prefereable for the drivers and the framework to
> > support "preprogramming" of the keys, when the key is programmed to the
> > hardware when it is set by the user.
> 
> This doesn't sound particularly useful.  If there are always enough keyslots,
> then keyslots never get evicted and there is no advantage to this.  If there are
> *not* always enough keyslots, then it's sometimes necessary to evict keyslots,
> so it would not be desirable to have them permanently reserved.

I'm still trying to propose solutions for the hwkm-or-raw keys problem,
trying to find a way to return an error early enough. So it's not about
the hints for frequently-used keys, but for returning an error if the
user tries to program key type which became unusupported after a
previous call.

> It could make sense to have some sort of hints mechanism, where frequently-used
> keys can be marked as high-priority to keep programmed in a keyslot.  I don't
> see much of a need for this though, given that the eviction policy is already
> LRU, so it already prefers to keep frequently-used keys in a keyslot.
> 
> > Another option might be to let the drivers validate the keys being set
> > by userspace. This way in our case the driver might report that it
> > supports both raw and wrapped keys, but start rejecting the keys once
> > it gets notified that the user has programmed other kind of keys. This
> > way key setup can fail, but the actual I/O can not. WDYT?
> 
> Well, that has the same effect as the crypto capabilities check which is already
> done.  The problem is that your proposal effectively revokes a capability, and
> that is racy.
> 
> - Eric

-- 
With best wishes
Dmitry

