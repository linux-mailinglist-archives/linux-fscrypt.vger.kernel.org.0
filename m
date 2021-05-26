Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDD73911C6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 May 2021 10:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhEZIEL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 May 2021 04:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbhEZID7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 May 2021 04:03:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170E3C061761
        for <linux-fscrypt@vger.kernel.org>; Wed, 26 May 2021 01:02:28 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id f20-20020a05600c4e94b0290181f6edda88so8030421wmq.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 26 May 2021 01:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QKYMHuHj0rbRUvGsShexdweEmy0NImIy2gA8dj6fkuE=;
        b=T5q7OTy6oO8Uxl4kJVPH+6k/22Oq4u5P5Syiyrm8N0Kkyl8yxvHJdzDg+3eN/NxRBd
         WFBgJEUvgpwQcSqbSbtepgsp6dCbHn3dD2+MR1kvmhmpVmSqDVOGAlGiT57y4is4cVKs
         kHbmcqWUi6HRepE51rTn7K+2enZHmTPlkL+Q2x4FhF3CPkZkJg8WQYnUQD6aqC/eWcp8
         soGqlEfvI00R3esiCgOJkykUeB1HizxPgfxD4BYr9CWoTtkuhagdPwb8F00WNQrHSRXP
         UETyn+MIeQvCxDco5L7UsXru93iZnIPVVTDYhug9eEhb4MUAJ/dec73GEj3k0XZmY84x
         etWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QKYMHuHj0rbRUvGsShexdweEmy0NImIy2gA8dj6fkuE=;
        b=mKJ7qi4gfzkcDIwQNDSOeVqiK/BSgfPhiwPYotsu+VtokhUeEhKuv6dYqxNzgOi78J
         IGbN9WV3ng0QHv2067r78+71qLDwegq7HUbVLkPRXbF8I4bugJwJwJ41EdDr1Zc5takr
         TM5XBVEGCn5wxTOEZCUIyYhw+f1PeRRgc4xVEorZFDS6cK1QEJ2w5wWmCJSMWzezgt0D
         8pSup/rof7+fiZ9aSia6hJLp9Q9dQWP5/q8Sunz1l/5EVRZ1Gm7OZPaq5ML2yAbW/cBX
         idP9BZXEcO7/RbfHK2jhIbCUsVD+sEQYDP6l2Q8I4P7iHgThGMrGEKwhMLxqau7ENYMd
         tWuA==
X-Gm-Message-State: AOAM5321R8kmfy8QkQtugX8K+fN0YQYDfo54huy9ANRMEUOPA7sNXGhY
        mKW2M3J6Nim0iBfglUpfu/XZNw==
X-Google-Smtp-Source: ABdhPJwrEx+pejVdZrENSeUjbsMmHQqcH7okPp5KpG7TvcFBGPoRuHHoqjtEN+zZbUOLp+4rBgmJNQ==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr2146740wmb.51.1622016146591;
        Wed, 26 May 2021 01:02:26 -0700 (PDT)
Received: from dell ([91.110.221.223])
        by smtp.gmail.com with ESMTPSA id l13sm5033812wrv.57.2021.05.26.01.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 01:02:26 -0700 (PDT)
Date:   Wed, 26 May 2021 09:02:24 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v8 0/8] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <20210526080224.GI4005783@dell>
References: <20210121230336.1373726-1-satyat@google.com>
 <CAF2Aj3jbEnnG1-bHARSt6xF12VKttg7Bt52gV=bEQUkaspDC9w@mail.gmail.com>
 <YK09eG0xm9dphL/1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YK09eG0xm9dphL/1@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 25 May 2021, Satya Tangirala wrote:
65;6200;1c
> On Tue, May 25, 2021 at 01:57:28PM +0100, Lee Jones wrote:
> > On Thu, 21 Jan 2021 at 23:06, Satya Tangirala <satyat@google.com> wrote:
> > 
> > > This patch series adds support for direct I/O with fscrypt using
> > > blk-crypto.
> > >
> > 
> > Is there an update on this set please?
> > 
> > I can't seem to find any reviews or follow-up since v8 was posted back in
> > January.
> > 
> This patchset relies on the block layer fixes patchset here
> https://lore.kernel.org/linux-block/20210325212609.492188-1-satyat@google.com/
> That said, I haven't been able to actively work on both the patchsets
> for a while, but I'll send out updates for both patchsets over the
> next week or so.

Thanks Satya, I'd appreciate that.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
