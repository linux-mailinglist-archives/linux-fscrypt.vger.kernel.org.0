Return-Path: <linux-fscrypt+bounces-1070-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C89D0FB5D
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Jan 2026 20:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2345F300162B
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Jan 2026 19:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C155352C44;
	Sun, 11 Jan 2026 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Sx3fkkWV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCB34B1A0
	for <linux-fscrypt@vger.kernel.org>; Sun, 11 Jan 2026 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768161397; cv=none; b=rvg0P8wcNLGqBk6A1gCwq6Qq5EHbXKWXaKlVON4Z7mdvFmnu3cwUkOuUyMFGlxVADVDwse6i7yujHbrloKEImviX2yuT0CJ5LH8/YQAfVOVjUE6ob9ccQ16moyAxwnsXuuze4osKeqZmJ8Q3i51sjQzbOmtLV655E2685dxsMUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768161397; c=relaxed/simple;
	bh=QHl7x7hOeSAon2QJW6cSB8X7QgA6HF5XK1F2xB7PV18=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=YRFld8K+7wQJQ5DChH2vMGY23KLZ0rC241+e+bWLr731q7MY4l//d/KO8R3mcy9mBGMB7ujcbzlp7Fb+tMCGCOx+bSFbfzjBP/vtmU6+U0FGrHH6Ubnm9PFOA/ZYPYU6yiSmDA7KJexGFsZgYSdUTua7ljehE/A0fa1YKWNZMzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Sx3fkkWV; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-3ec47e4c20eso3627608fac.1
        for <linux-fscrypt@vger.kernel.org>; Sun, 11 Jan 2026 11:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768161393; x=1768766193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGVfI0/8+u4L//09+zks70nTh/iqSyXGMYjvkVqtgSo=;
        b=Sx3fkkWVBZHHJM9n3IWzYWTNAd2N+/izn1DcVhnV+Wmjk4Rghjlq3gSRADQ7AQeeqz
         oacE+X2y/0yWzZ8ASy63UfQd38q0z/m8SJHcXKoEMfA/HAeONmanViEoJYDHnrwVhN3K
         gnsmAhviinhaWy/CpHl4EYjKOcvuFM2nLLcNB5geM3geKuJwq3oXV15i2cw3VzPx2iOh
         pioNQsvF5/2eufmkwAYVErcunNfUqi0F0w2GKlHqt1TEk2AP59jxSjgCl8btmv02HYvp
         tYshpkcVVox6fmV6u8IVBo2OiZ/ODgsZt98nDLVUtUIeCGbxmfBnNOyqZwBZo5EBDsor
         27WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768161393; x=1768766193;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fGVfI0/8+u4L//09+zks70nTh/iqSyXGMYjvkVqtgSo=;
        b=eHgtf4iyFqRks2Dlhiym+PCNOC/LEaZvLodWy5iZ0cffWW4zyCB9lOsbC+kWnM/RYN
         5zz9Z3VCA2alYmIooeZxondrn+ulGS5SPy1c2I48Ezn8h0rwUJRryXI4/KIdEO71Yb0w
         SjbbytAHRdt14WrnaOF7CSCyuu0sss0X4D4ct5xea3H1bCpvIssAUzUpwlowGKrsSwP0
         DPet+iTT0jQ932OjG9S3tlclXnetvN0MrCzbrCPp9ShHF6pD9KZefcg5gc7kabzSQ8yZ
         SzYR4HoO63cxYqoqCGgNQIwFieN+CI7sZAfewjzVlaHitaKZFQknYEDp86POjI3/kcA2
         b77Q==
X-Forwarded-Encrypted: i=1; AJvYcCUraXEL/4bR+LqWlC7NMQ6zcItsyoLI2D9jFTdoqJ06OBhwbMRg/CKBzD5StaFoov3yakQYSghFb9oDFQcm@vger.kernel.org
X-Gm-Message-State: AOJu0YxfROFt22nPoDe6FEy+g3e8o8T1tPsttMbr3otmUgauWLVgpxdB
	G/Boprulnlk56Xu+T9rJuKC07yhcnxIoyOmM8U6FxAPlpcgrK92sxtlW8p3FG5hwOyNJTnOtSY0
	pdqNY
X-Gm-Gg: AY/fxX4AIZEZnSnTBCLffye5PF5Aiu8OmKjOEO11sATpqYS9eAx5W+ZNHyqRZ0lXrAL
	n9cJSM8AlyfdJkmksv/706JDuCpQhhCMyWerFZwK1Men6SHOZ+gfVQhAJvbJoqlL75oGZl0EAxr
	lW+CKcokaQ3ZtauKxNK6futE9GYeJxHn4YLazp9eZTpRTFIGxURT3X5HseHjwOrlp1oa/GHl2eZ
	jGOAJYT8NrLJdc7FlvGWW9S/UmJlw9oduf/i5nYBdMnRNhkLxyKo4xgRqtGVXnHxYlOcJl/B0lr
	Q097z+7SHvMswNy31LvA0VVCEZXu9tTBrwqsGDE0OSqWgJZk/nbeenKIaHoGe27qbphJBmu8Yhg
	k7diZF5LElOdT/YMWdx0+ukfcJtb+bSs9TGbFLEFk9+c6Jahc2cGmIkEFIiAlsb0X++GzLiZ04+
	1W4Ce10Lp3PQo/ig==
X-Google-Smtp-Source: AGHT+IGBtFi/oNMknJ7q23MRiHrgmzqkvOyQcIAGMR95gDlAmxm0egBAU8gy6B6FNAE/n6bQHA+jKg==
X-Received: by 2002:a05:6820:168d:b0:65f:674e:f1ca with SMTP id 006d021491bc7-65f674ef243mr4958633eaf.35.1768161393624;
        Sun, 11 Jan 2026 11:56:33 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48ccfbdcsm6306629eaf.15.2026.01.11.11.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 11:56:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org
In-Reply-To: <20260109060813.2226714-1-hch@lst.de>
References: <20260109060813.2226714-1-hch@lst.de>
Subject: Re: move blk-crypto-fallback to sit above the block layer v5
Message-Id: <176816139201.218180.16174213874094266429.b4-ty@kernel.dk>
Date: Sun, 11 Jan 2026 12:56:32 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 09 Jan 2026 07:07:40 +0100, Christoph Hellwig wrote:
> in the past we had various discussions that doing the blk-crypto fallback
> below the block layer causes all kinds of problems due to very late
> splitting and communicating up features.
> 
> This series turns that call chain upside down by requiring the caller to
> call into blk-crypto using a new submit_bio wrapper instead so that only
> hardware encryption bios are passed through the block layer as such.
> 
> [...]

Applied, thanks!

[1/9] fscrypt: pass a real sector_t to fscrypt_zeroout_range_inline_crypt
      commit: c22756a9978e8f5917ff41cf17fc8db00d09e776
[2/9] fscrypt: keep multiple bios in flight in fscrypt_zeroout_range_inline_crypt
      commit: bc26e2efa2c5bb9289fa894834446840dea0bc31
[3/9] blk-crypto: add a bio_crypt_ctx() helper
      commit: a3cc978e61f5c909ca94a38d2daeeddc051a18e0
[4/9] blk-crypto: submit the encrypted bio in blk_crypto_fallback_bio_prep
      commit: aefc2a1fa2edc2a486aaf857e48b3fd13062b0eb
[5/9] blk-crypto: optimize bio splitting in blk_crypto_fallback_encrypt_bio
      commit: b37fbce460ad60b0c4449c1c7566cf24f3016713
[6/9] blk-crypto: use on-stack skcipher requests for fallback en/decryption
      commit: 2f655dcb2d925b55deb8c1ec8f42b522c6bc5698
[7/9] blk-crypto: use mempool_alloc_bulk for encrypted bio page allocation
      commit: 3d939695e68218d420be2b5dbb2fa39ccb7e97ed
[8/9] blk-crypto: optimize data unit alignment checking
      commit: 66e5a11d2ed6d58006d5cd8276de28751daaa230
[9/9] blk-crypto: handle the fallback above the block layer
      commit: bb8e2019ad613dd023a59bf91d1768018d17e09b

Best regards,
-- 
Jens Axboe




