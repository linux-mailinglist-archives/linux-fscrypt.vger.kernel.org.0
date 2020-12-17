Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBA82DD41B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgLQPZW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 10:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgLQPZV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 10:25:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D68C061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:24:41 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id t8so19236202pfg.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kIz7GYcd9kc7NiTcGubc3hHNTjDCxZzzCffmZhlzieY=;
        b=HdoR+iFCYRI8AX3ZC7L1wYTUXMHVnCkfMb7AsbGtq49mvOe4eaYbBaXdPeS/tOggjh
         iaGCtAS6t/o/Dw6Km6dwfoP5Kn4RuOjK3o0f7FbZMYEwR5xRRpoh45/UEPDl0xYQxPwQ
         rQ3ilEs3t8z2AMU7jLByMRyXgtvAe5MCCqWUjZnRO/EutWuf2E9G8vKVIo7AWHN8FXnU
         xQ3cAH1mArHyt/2iHI9koyx5v1B/Tn5ruroIIn5q13cbbGDaM2CckDP0Zw0+5LbcwKpb
         QIITTuK0z3KpzYvw8oEGE7wj71OzKAsgh9qTnSqUSqY9IPOA+7TjA/8YF2ebPkMJYwnq
         c4Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kIz7GYcd9kc7NiTcGubc3hHNTjDCxZzzCffmZhlzieY=;
        b=orStudek2l8ZAuywS1F4CnUEdLg+ihVD0i2IP9HIhoiS/x+HUnLbzbIE1Q1SnMxT5P
         oe1+SI/JL5GBzXx5b7PMnAeesYN2knuA1883s3dFTBVnwqN2dYfWBecRY78DEJK8E4CN
         OXF9ySsYm3vK4/8VE0TnqS4UyD0UMcuOUSwLYmNN+Ol9Zks3clhuiJ9haTkbWFVe4Ysf
         sWANBxLYAcsC85ur1t6QYT6EmiohzCVME96CW13nHhgYcbTuuDwJgVBEOh0cYzuUnaJZ
         EYqzHq1NR7F2ueA1aQa5no4xg9WNxpHmq/4PYGgUEyroIheNwJp5f/KBbxJOsUcLLMWa
         fA2w==
X-Gm-Message-State: AOAM531+2y4RKa7BJDtXlFlDRhMKREZmQfsB2wQr3/ddymrcA++ol9sp
        hB9S4wH3SORm78e485ZHbwILCw==
X-Google-Smtp-Source: ABdhPJzOVkjbRMywF5FZEc40FxzXtgaCv38qyhyJ7q4OV4GZm3JysAsFd7f3WjwnxMINhtTfcXvOCA==
X-Received: by 2002:a63:2347:: with SMTP id u7mr18664863pgm.189.1608218681110;
        Thu, 17 Dec 2020 07:24:41 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id h12sm6466839pgs.7.2020.12.17.07.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 07:24:40 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:24:37 +0000
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 2/3] fscrypt: Add metadata encryption support
Message-ID: <X9t4NXGM7cbxsimQ@google.com>
References: <20201217150435.1505269-1-satyat@google.com>
 <20201217150435.1505269-3-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217150435.1505269-3-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I'm not yet done with the xfstests that Eric asked for - I'll send them
out as soon as they're done.
