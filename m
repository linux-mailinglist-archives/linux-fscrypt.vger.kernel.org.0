Return-Path: <linux-fscrypt+bounces-210-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 000A886F106
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Mar 2024 17:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8358F2817C5
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Mar 2024 16:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7951B27A;
	Sat,  2 Mar 2024 16:01:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6B518B15
	for <linux-fscrypt@vger.kernel.org>; Sat,  2 Mar 2024 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709395291; cv=none; b=XuX/kbeVyGY98REtybLbngBfV+ZzO3c6vfDctvkrhYOdatscjyDohCoLV0hfNffKIQqdiFswjTlWH/8+0S2M2WGkykm/4Z4Hi5JQqwDZTRvIlj6UMaaAnSAZHJAg8UJ/M+rJdmBXruXFBhvax0ywgpOpoWExG5hLXvc1pIEpuAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709395291; c=relaxed/simple;
	bh=LFiAtGjubDWpNLUQxtbJ/E7SHByKNPAdC4jbSr77kCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gbo7frBjrrZjhw3+C/zO5Qh2qadX27AC7q7z9VbIKVDiQtR2rPfGlp/o+q7o8VOkee31q1pbjCygbVZlrKmno5Prb9ra1sgT6xNYx70iuD5TcmXZDFpDsBXvfaDHGpUTmOYgG2uGbSjbD54sSgjbWAzgHqS4CtTkCHy0Dly1rso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-68f9e399c91so24601966d6.2
        for <linux-fscrypt@vger.kernel.org>; Sat, 02 Mar 2024 08:01:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709395288; x=1710000088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XenCVyPUGE/ocH2LizUOZPuh6vZd/WYCNYixpMDiLyI=;
        b=AOMrCoTEctOq0Y1k1G5xt7RpavxssUOeZXbFfoo+N6rnENk+Wf8gruzfhjGWt2r8rE
         6E8QB7IAk/3TtSdH4E+dF1C/o0C/HXD4AexvZBQk1qhCWtoo2i5CtLbe97yN8dXbzjvg
         MB1qNnJmPPv/HOC0numuSR0W4s9YsMM4frOxqPg4BmpRSEPwD5ekk1n7yE/380saaACk
         thr9KCzwVV/b1vCkNWgQ6kOa5mHl+cZnri+bonpCIm3hsD37RaN38qwChPGFN2jmwWPl
         /Tpbcue+KHCsRy4v2CB2p6LeUfrBYEW3JDdaLiliTJoheTfAtfj2qunvpcwblaeGvOy7
         Ww9A==
X-Forwarded-Encrypted: i=1; AJvYcCVINBw3vymJEaOZIZEMQX4kwiFg1lT2Hn1NF6u3xdAV9BczxnX3f4mRtMIIVaT0fqDNw2KbXKwCm83cLyqu6FuvqvZeuhAPgtFfc2tXig==
X-Gm-Message-State: AOJu0YwTibHPAkGxUyO4rrZ+i/0QpxrxztTNFpsv4j7EJ2uWRxbPLy7x
	3tsVISGOEpRlOZ8odiVagA7Mz/thXBIRZbWg3uqiwjFbrhTBefQ7WxHTKH30Xg==
X-Google-Smtp-Source: AGHT+IGzvxitZoqsBYuFgO2HzG9/T+9mfzbc+Y/oQjpPYffJx1lNgpS1DLq5H2YZNnh++/V9NyR/5Q==
X-Received: by 2002:a05:6214:57cc:b0:690:6b94:67fb with SMTP id lw12-20020a05621457cc00b006906b9467fbmr9186qvb.21.1709395288340;
        Sat, 02 Mar 2024 08:01:28 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id me19-20020a0562145d1300b0068f85706ecfsm3064940qvb.104.2024.03.02.08.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 08:01:27 -0800 (PST)
Date: Sat, 2 Mar 2024 11:01:25 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
	serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
	axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
	paul@paul-moore.com, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v13 12/20] dm verity: set DM_TARGET_SINGLETON feature
 flag
Message-ID: <ZeNNVWxkhki8lX55@redhat.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
 <1709168102-7677-13-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709168102-7677-13-git-send-email-wufan@linux.microsoft.com>

On Wed, Feb 28 2024 at  7:54P -0500,
Fan Wu <wufan@linux.microsoft.com> wrote:

> The device-mapper has a flag to mark targets as singleton, which is a
> required flag for immutable targets. Without this flag, multiple
> dm-verity targets can be added to a mapped device, which has no
> practical use cases. Also from dm_table_get_immutable_target(),
> it documented that "Immutable target is implicitly a singleton".
> 
> This patch adds the missing flag, restricting only one
> dm-verity target per mapped device.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

FYI, I have picked this one up and staged it in dm-6.9 and linux-next:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.9&id=9356fcfe0ac4a8545f9fc32f2e404524e1115ee6

Mike

