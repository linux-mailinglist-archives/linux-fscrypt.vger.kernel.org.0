Return-Path: <linux-fscrypt+bounces-550-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 312969EA0B0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 21:55:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A170F188631C
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 20:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D4319C54A;
	Mon,  9 Dec 2024 20:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kc7T0fp7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191731E515;
	Mon,  9 Dec 2024 20:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777756; cv=none; b=mJIfikm5/UxCY6nr+rBRGupdtWERgJzTGxmLPtYatq/uz6uW2KV5fx/8FlnjEHOIy3g7VbgT1hp7Z9MeHp8JKL567+Hq0jJdHloBwiQXOAXQ8Wr10XQFiAaWqrCm0/4nBjQQyTnKXtNobxX2BQNFbVWUsrro3nv0oVoOhmEXM00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777756; c=relaxed/simple;
	bh=sOgXmVXOEnzT7dUlGozpoOeQowFqZSP83pipX0+N+CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2Zcp7iz/t3WiJ+tVbMByNlJzHxy8SUrH10YJovHSCOtYx7jzmg6JNTRNhHvcKmqjxhfbOeuD1nek2irHPOxvDgN21reOnERBEc+2C5t5vWIaVbzooZtCKAnwbYICEhwb6KfVDay5s0M+aZ+K3PHrKqCcZiaclxHxRg6KqaYe7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kc7T0fp7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684BEC4CEDF;
	Mon,  9 Dec 2024 20:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733777756;
	bh=sOgXmVXOEnzT7dUlGozpoOeQowFqZSP83pipX0+N+CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kc7T0fp7U/kfgCVYqCSBWyEw5nXhU+20/Q/1Kp5gy5q8ilJzSe8m7+5RUOtBM2oq/
	 et4sz5xMsvxFRRuLWae9iPhdrEJnUjTyJVfenzh2Z2t+Ct90H/yEs310Vafb0KaoVg
	 DCTCJHmOwTLO8e4uiANX/d7Rk72R+4QytWyw8AQBH3JdZgXjSLH38K5fl0K9XE+vjN
	 DyStQ+w0tz1HHTKw8vMHkoxexcWRBTtbTOIOdFqNZyImqKzcbbt2JvvB2F4Gf4d6Ev
	 dLIkK1tev0HW7zh+50gWRVzP9QWsuY6GVYa55Ei8/RNnWRlBOa9ciIAfDiE/Y8bXPQ
	 R8ANvT3YcVRZw==
Date: Mon, 9 Dec 2024 12:55:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 00/12] Support for hardware-wrapped inline encryption
 keys
Message-ID: <20241209205553.GC1742@sol.localdomain>
References: <20241209045530.507833-1-ebiggers@kernel.org>
 <CAMRc=MfLzuNjRqURpVwLzVTsdr8OmtK+NQZ6XU4hUsawKWTcqQ@mail.gmail.com>
 <20241209201516.GA1742@sol.localdomain>
 <CAMRc=Me7kEBHW1BTDkJ6w+3GjucCfC+GNZBch3kX=gsZniFHvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=Me7kEBHW1BTDkJ6w+3GjucCfC+GNZBch3kX=gsZniFHvA@mail.gmail.com>

On Mon, Dec 09, 2024 at 02:35:29PM -0600, Bartosz Golaszewski wrote:
> On Mon, 9 Dec 2024 21:15:16 +0100, Eric Biggers <ebiggers@kernel.org> said:
> > On Mon, Dec 09, 2024 at 04:00:18PM +0100, Bartosz Golaszewski wrote:
> >>
> >> I haven't gotten to the bottom of this yet but the
> >> FS_IOC_ADD_ENCRYPTION_KEY ioctl doesn't work due to the SCM call
> >> returning EINVAL. Just FYI. I'm still figuring out what's wrong.
> >>
> >> Bart
> >>
> >
> > Can you try the following?
> >
> > diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
> > index 180220d663f8b..36f3ddcb90207 100644
> > --- a/drivers/firmware/qcom/qcom_scm.c
> > +++ b/drivers/firmware/qcom/qcom_scm.c
> > @@ -1330,11 +1330,11 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
> >  								  sw_secret_size,
> >  								  GFP_KERNEL);
> >  	if (!sw_secret_buf)
> >  		return -ENOMEM;
> >
> > -	memcpy(eph_key_buf, eph_key_buf, eph_key_size);
> > +	memcpy(eph_key_buf, eph_key, eph_key_size);
> >  	desc.args[0] = qcom_tzmem_to_phys(eph_key_buf);
> >  	desc.args[1] = eph_key_size;
> >  	desc.args[2] = qcom_tzmem_to_phys(sw_secret_buf);
> >  	desc.args[3] = sw_secret_size;
> >
> >
> 
> That's better, thanks. Now it's fscryptctl set_policy that fails like this:
> 
> ioctl(3, FS_IOC_SET_ENCRYPTION_POLICY, 0xffffcaf8bb20) = -1 EINVAL
> (Invalid argument)
> 

Yes, as I mentioned I decided to drop the new encryption policy flag and go back
to just relying on the key.  I assume you were using
https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys?  I have pushed out
an updated version of that that should work.

- Eric

