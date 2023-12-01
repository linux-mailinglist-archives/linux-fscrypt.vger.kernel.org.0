Return-Path: <linux-fscrypt+bounces-40-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81497801628
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 Dec 2023 23:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB469281FC5
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 Dec 2023 22:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508EA3F8D4;
	Fri,  1 Dec 2023 22:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="XEF82ezl"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F20310F3
	for <linux-fscrypt@vger.kernel.org>; Fri,  1 Dec 2023 14:15:52 -0800 (PST)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-5c08c47c055so29109277b3.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 01 Dec 2023 14:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1701468951; x=1702073751; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WY7hOTWEtHRPj5tXJZlLn9Z44W1TMg+N5RE6QB+aQfk=;
        b=XEF82ezlRlUsEHWIWjdakp5PNwBXcCCadIa0vxXFEL4usD8kkyf6fMquriqIwNxEX7
         CE46cTvinpMx27rq9l1tVnJguBMXJy+a1WiNAidlV/VPQL+RM7y0L59uLOQsJpByvqg8
         LE4GZjpvCvrqgf2C3orZ4K8Q4aBoKigiRADUYEUu+5V+rzegrzvNu7DccMxU9+bswtgf
         uO/0DjzWQiaTuu6ODo2PuRIcBxOCBNWqzExDxD4WbjeJY00rCY0rSCRs3OI41OD5ddW5
         1azNV3Edoqb1GHCoct3ydl7YeMK+3ElehCRfyTXKYretBnBbwhiGEYL2ig2Q2K6XKUV7
         7+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701468951; x=1702073751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WY7hOTWEtHRPj5tXJZlLn9Z44W1TMg+N5RE6QB+aQfk=;
        b=h7uoBcdkVYDqNok2yq2VXjsp1avVaUbgqYB0uDsYmskzF8/V6F1FV0twa1xrP0B72m
         qpNjKwFfUd50+hk7KSiOKKr7RjeRQULkjOz7JPqIq/Dz51QzwRnR2wVGtD8W0/gfAdQY
         0JqnazgbKMFmREfWCSz80eR8kaKEruHcKpIKqAr2RPgNUFu8ZjwBVejsHMT0mMLhznXi
         CXIZIsAUM08WJwcc+VwosIlBhQYCAd+tNejZlHj1bd61zp2v5aNI3wv2zlTpXTt8pnNK
         iZhEJCOC0LeWeXIBsbCVXxMAGV/Wj6qgx9XiW/iKzvpgZR6MuM0CYgCHrni+DBCCQqY8
         gA7A==
X-Gm-Message-State: AOJu0YwHpoJsnnAarzkWVfMVuYdqTwGGvYSTP1RDcs6aquADknnstGxW
	pGxQfb5mNKsEBCsR5I8YQtUosg==
X-Google-Smtp-Source: AGHT+IHiBhH5VV0CSOk58iSOuPzB4Wj5Lj6dMJFizlIaMBtIyJnaHxyDL4CELEEKRuYj9CETGr3c8w==
X-Received: by 2002:a81:98d3:0:b0:5d4:3013:25da with SMTP id p202-20020a8198d3000000b005d4301325damr288754ywg.24.1701468951493;
        Fri, 01 Dec 2023 14:15:51 -0800 (PST)
Received: from localhost (076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id t9-20020a817809000000b005d3500ea9fasm1362869ywc.10.2023.12.01.14.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 14:15:51 -0800 (PST)
Date: Fri, 1 Dec 2023 17:15:50 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org
Cc: ebiggers@kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4 00/46] btrfs: add fscrypt support
Message-ID: <20231201221550.GA4134816@perftesting>
References: <cover.1701468305.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1701468305.git.josef@toxicpanda.com>

On Fri, Dec 01, 2023 at 05:10:57PM -0500, Josef Bacik wrote:
> Hello,
> 
> v3 can be found here
> 
> https://lore.kernel.org/linux-btrfs/cover.1697480198.git.josef@toxicpanda.com/

Sorry Eric, it's been a long week and I forgot how to use email, didn't cc you
or linux-fscrypt on this series.  It's on fsdevel and the btrfs list.  Thanks,

Josef

