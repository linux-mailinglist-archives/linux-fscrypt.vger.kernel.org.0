Return-Path: <linux-fscrypt+bounces-547-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A229EA017
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 21:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D46A52827A1
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 20:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6548E849C;
	Mon,  9 Dec 2024 20:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScXLTqpD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6631E4A4;
	Mon,  9 Dec 2024 20:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733775319; cv=none; b=Narukb70WwzIBuj5gvPaoL4CuGH2f8FlJzpCCiJbu5jYrWzsi1GUvgxrGhph4Pn7FGJlALpdVxaAm1KHKp19kqqbjgxQ/Q5oRUHiM7isusGTtHKjlSaOf1Y5LRsrggAdGKbu/16ckuk+A7gS6iD0A+pys41kwQZ9tBz0r6Ik19k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733775319; c=relaxed/simple;
	bh=JNFCf5zDF2ZdQHEIxpM42zybxCUP5ZMeLbhFxfcWcg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyXY66p9ncThQsW6icHvhTxZB2Q2hJDQodtYCysTFifGF0iGQFWPoL8HSokd5RoM9sfZfNKHc2lhBht10IkCmoHkmGlfaQeJClLTWXpIBGU8PRB5U5IPY6B3Jfxm8f3WeAirlu6YlL0h/7wfu52Qjz2f+Y7wQim/tpwYXH1DrIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScXLTqpD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FE6C4CED1;
	Mon,  9 Dec 2024 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733775318;
	bh=JNFCf5zDF2ZdQHEIxpM42zybxCUP5ZMeLbhFxfcWcg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ScXLTqpDfve40++H1c8OwW6ROD6yxd0YY5u6VFOTw21hi4o3ZcQmLsIapdBSujEV8
	 FRUBn4+MT5wNeBaMpkhGqv6b6fVyYVl3GSF14gAwy9SwHMrrEIK0mXO8C83nkg0Otq
	 S1OoYw09iMAezWg7EYRlwKNY/ah44I7pylrCsK/D51uKtkfr6ydJN3dJUYaCED7TjX
	 DKwg0e0zOhFLBmhvw+34WLxjJiCRtCD6jOHPWENi1UszGZIqjtaLbOMnXxI0NoQuhp
	 UdbrX4z5WSgrHtPpjUqsQkWvFQRZKpLk36GOKfBbOQJhvYOyDIEht59EAhAzz87ivW
	 04yeQDtnkT5xA==
Date: Mon, 9 Dec 2024 12:15:16 -0800
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
Message-ID: <20241209201516.GA1742@sol.localdomain>
References: <20241209045530.507833-1-ebiggers@kernel.org>
 <CAMRc=MfLzuNjRqURpVwLzVTsdr8OmtK+NQZ6XU4hUsawKWTcqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MfLzuNjRqURpVwLzVTsdr8OmtK+NQZ6XU4hUsawKWTcqQ@mail.gmail.com>

On Mon, Dec 09, 2024 at 04:00:18PM +0100, Bartosz Golaszewski wrote:
> 
> I haven't gotten to the bottom of this yet but the
> FS_IOC_ADD_ENCRYPTION_KEY ioctl doesn't work due to the SCM call
> returning EINVAL. Just FYI. I'm still figuring out what's wrong.
> 
> Bart
> 

Can you try the following?

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 180220d663f8b..36f3ddcb90207 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1330,11 +1330,11 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
 								  sw_secret_size,
 								  GFP_KERNEL);
 	if (!sw_secret_buf)
 		return -ENOMEM;
 
-	memcpy(eph_key_buf, eph_key_buf, eph_key_size);
+	memcpy(eph_key_buf, eph_key, eph_key_size);
 	desc.args[0] = qcom_tzmem_to_phys(eph_key_buf);
 	desc.args[1] = eph_key_size;
 	desc.args[2] = qcom_tzmem_to_phys(sw_secret_buf);
 	desc.args[3] = sw_secret_size;
 

