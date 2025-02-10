Return-Path: <linux-fscrypt+bounces-600-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20317A2F459
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 17:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C41EF162203
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 16:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E64256C60;
	Mon, 10 Feb 2025 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EEK2NvAK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4660256C69
	for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2025 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206499; cv=none; b=T/qYV8ebbr4JELUF6P96ubF1kShzx79pW22Jwq0YRd2WiGGKspKplA0xfVfLChe7+mGXReMsDozEQExH+/k4ys/FizcaU8Icv3kvEhpfqmpsWmxxkZWnVj0Sg1IMuO/LQdK2y7Mc7gfagdELQpoUNBsPqwd/r6CzUK05OaITMYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206499; c=relaxed/simple;
	bh=wZAt1whlXvPo2Q1b3Smutb7wMRiPUZhVkP2+sI5mmfE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bdL6fqEhLBqf27mXa06R0nCrPEn+Rrdnb6x1Xg47bZLowTCarH+OWY8fVRxYL3+eIEqx0lrYaQjXLByllE/PyMZDP7m4kD/NKDt8hwv3bFl3tGjCfzFiXzuPUTfnM3jVRiusoSUe1KCPNB7Lgf+3mm8IVq3JrBnKTSGEy9UR5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EEK2NvAK; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3ce873818a3so44660055ab.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2025 08:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739206497; x=1739811297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PMYtp94b1is643OuACwo/j12Ah7BR/XT3SC/e2pDuM=;
        b=EEK2NvAKPWynbUphfQLW3JALxZk3eTEAgOt7UDWFhkD1ggey+S+1IlA22MoQc9Rfur
         Z9rOOBIF9ss+ERLQmTbob8SdCB5UI/Xjai+s7g8fHOV+zsnlsXEHXtm13z1tBcVKLzpk
         K6WCLIXy3HnpE/7AXnPrvt/2IC4IQCzqQESz1i7brXXNnvcm1nbh0bq1wXyZAc+aWbzW
         7VnEJzB0RID2nQyvAD9LURFTfGRCh/M+OI7r9f7h3LMDMcEaUWQyYCtdN1y2w+0wPziw
         sYAJVEd6d3+PudbG/zJ6hugV5P7mmuHVgr8Ny4IXRaAY4LmhLl96GNZkNQNbXzNQDmBx
         BcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206497; x=1739811297;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8PMYtp94b1is643OuACwo/j12Ah7BR/XT3SC/e2pDuM=;
        b=GTpI7rlvY6w7iQBjAMwy1+uiJJd2YbYboZHw6VGpCGinV989tuLM5nNphtz4LnSfWa
         qVyD6nT1QQQBwan589HZOUxLchz/a98V1x4b0qf9iRFA9F6MSuE16WtO1YiTdePDL1J6
         8crErY2oZtlLGNYmgElJnFKC6ngpZQFn7a5WW2jJkcf1Hm7J27JhYwKD+3U5/AU/iSuB
         ARnzKqQwGf80WsodY9/QjgRD4xt5VwIQCwfmlbOIqQSc9NMZUgyDCeLYvwgM848mye7T
         BkGtPfW9r5CLlGz4XDULx8ZYQp15y5adr8eTleXSvCrvslTTSKedu9cxT+oQ8Ux1xcOr
         GQUg==
X-Gm-Message-State: AOJu0YwKxbEqp7PTiqcFA8IyF3bYr+3yGLKZ8jM2sGKdG6Idy7KyRURa
	rK3rh1GsMmygyyjqG5cAwhFXh1wzBBTkaG3tFU28z+e5lKCB/opWsENfW4TVEMU=
X-Gm-Gg: ASbGncvqFExax8KWhNRY69VLz7P9om4S1mfnvt2oJ8xNUyIYDJLV1e00uYn1cY6UYbJ
	fh6pD9iZsHV7SJnIKJHXgIjqkSapmhiVmazDyOTT4sRIBd1zmwXfZeyqEyrNu9gYcdsnPXbYWKX
	Fzqe5gOBwOzTTLHrc9WLIJG9x5nx1dJY0/OHwFx+pqbfk99KAZoJZhhtQf+0jqCwqQY4Qoir46u
	DeWyMjywpHlDGDIjW/tchEEAi7USJHdSuwcvz5dExNS0Zr7IFNR+TBXmS1gGpkZB9Xi7ZMoMT+/
	QjAZKWA=
X-Google-Smtp-Source: AGHT+IEKwKkbjlM00wUkqD43ricuqMhdM5OtDdfTR4TyublFdzI2jLfPM5oMenNdauctjvOXP8xpKQ==
X-Received: by 2002:a05:6e02:1aa2:b0:3d0:1932:7695 with SMTP id e9e14a558f8ab-3d16e494554mr5686395ab.8.1739206496700;
        Mon, 10 Feb 2025 08:54:56 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ecdb903a89sm1796514173.70.2025.02.10.08.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 08:54:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20250204060041.409950-1-ebiggers@kernel.org>
References: <20250204060041.409950-1-ebiggers@kernel.org>
Subject: Re: (subset) [PATCH v11 0/7] Support for hardware-wrapped inline
 encryption keys
Message-Id: <173920649542.40307.8847368467858129326.b4-ty@kernel.dk>
Date: Mon, 10 Feb 2025 09:54:55 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Mon, 03 Feb 2025 22:00:34 -0800, Eric Biggers wrote:
> This patchset is based on v6.14-rc1 and is also available at:
> 
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v11
> 
> This patchset adds support for hardware-wrapped inline encryption keys,
> a security feature supported by some SoCs.  It adds the block and
> fscrypt framework for the feature as well as support for it with UFS on
> Qualcomm SoCs.
> 
> [...]

Applied, thanks!

[1/7] blk-crypto: add basic hardware-wrapped key support
      commit: ebc4176551cdd021d02f4d2ed734e7b65e44442a
[2/7] blk-crypto: show supported key types in sysfs
      commit: e35fde43e25ad725d27315992fba8088d1210b01
[3/7] blk-crypto: add ioctls to create and prepare hardware-wrapped keys
      commit: 1ebd4a3c095cd538d3c1c7c12738ef47d8e71f96

Best regards,
-- 
Jens Axboe




