Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C822DD3F2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 16:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgLQPQt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 10:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgLQPQt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 10:16:49 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1DC061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:16:09 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id lb18so3803623pjb.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0X1DCRxzloLcq/I12JrF6wjku1BEW6h4ePAndekIaw=;
        b=s1yiqE9QLy0+JQiZIk1aZzccQ+uRiZHhNx0Fttnf8TQNySsbgwfOXZcDayNIbHABQ2
         JcQV4o+eApR1pEh8bZgVUABWjLVErV2zCfb9wsjVttbxSRWgw18xcvqEg8PYX/i2EIT0
         2k6ROrX8kcB6QHpfuHKYVi6pW6fribJgrLqADDZImEVnohh+Nk2Cim+33/eFG2Zh6LhR
         FrR9kjSajTzGJiapkuZ6/km8EPRv6lCuB4LdzU1QPa54GobhOXKwIwkh5v3HZMb1Ozcf
         1bp4XBJkGrczRdGslpVrTqRn5BYARI1Iyj6fv4Yc4FSVVZA7HMVugYpWcEFX8f8DzeUc
         pJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0X1DCRxzloLcq/I12JrF6wjku1BEW6h4ePAndekIaw=;
        b=PArpFEKru/VnrKy71rQSQBGgOO50tROEZWFVT4myPAwHwJr1pQgv3VNSOWZyYBH1DF
         Gl5cY4+ckI3ALyY3++dJnG4GPWX19VSfG0AMdFkqAaTUYwmoF3ioN8GJB5DKSS0uFzL6
         MHDgFsOqOBS6HC0yBnc/ywuCTlpowWYtRkwZqTvCti/YXGhfK3PStvGQ/mPGN1VhsTju
         JECBOYBmTM8k8WnpkiIBqpr8f0f2HKBvhhSNr+EELVU8bG9HLC3L6UDWIo8FTmfqtTtg
         ypme0m7Vo2NdKvaTmbbAqguHOY18sKRozxDNA5yBWkN5NcJE1rXgBCe0uFDdrTGt9lhA
         xQiA==
X-Gm-Message-State: AOAM5313uvg0nboh47jgr/dY/UdjqoUopgKnfbZtFjm38pzPDI8IeizB
        7ABe7Kkm2HktJK/xAAHipC3d/Q==
X-Google-Smtp-Source: ABdhPJzQYg4oUBNvdjWLc8LfDykAYEzEOhexJBoTKWfgUrSF2bq7qGnn3gDCM/TCEpYCQTCi0SIYaA==
X-Received: by 2002:a17:902:7292:b029:dc:ac9:25b5 with SMTP id d18-20020a1709027292b02900dc0ac925b5mr11849098pll.2.1608218168617;
        Thu, 17 Dec 2020 07:16:08 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id 19sm6248598pfu.85.2020.12.17.07.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 07:16:08 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:16:04 +0000
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 0/3] add support for metadata encryption to F2FS
Message-ID: <X9t2NKf/h7XjzOQA@google.com>
References: <20201217150435.1505269-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217150435.1505269-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 03:04:32PM +0000, Satya Tangirala wrote:
> Changes to the userspace
> tools (that are required to test out metadata encryption with F2FS) are
> also being sent out - I'll post a link as a reply to this mail once it's
> out.

The userspace changes are at
https://lore.kernel.org/linux-f2fs-devel/20201217151013.1513045-1-satyat@google.com/
