Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2D7134A99
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jan 2020 19:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgAHSnM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jan 2020 13:43:12 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46715 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgAHSnL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jan 2020 13:43:11 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so1458605pll.13
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Jan 2020 10:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GqM7/Gox89N6RYmX8N+C+JYNDY9Y92t5hXeig9A+0NE=;
        b=U3nfmbMHq/W60Cggp7RJIO+vjwZF+eOByq0zw2NdD3Ar4SSHaOIVputw0PVblX2/o4
         rGuycl8hULEeLa76n6VKtiejtrAZxV2ip7LKG2pkIUppk7kP+nYsoJH8PIA2ERd6eHZF
         7kg8c8oxe1HfsuNiPK04ZvCZVI7p4MrF4wrplzGBHJ7+0t7oRiI5MUorB0njq6uxH/p4
         g3w3/0xI8Flgn5SK4qw2rmZOVRk4uCUJbVGYc+4YUDe02CHqfod56+BNdpYqpkr4u4Ju
         QWRtvYtE+1qc0bdsIr5YDGmM3klH/1hIseMl+g3jErzlysuBDR4N36fNB1+B3orn9fso
         nn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GqM7/Gox89N6RYmX8N+C+JYNDY9Y92t5hXeig9A+0NE=;
        b=MQFhGMJ8tRfdNf9mmT6w/Cgs1f3UF6mpumg6M7AfbRcLKwhEe74jSpAi28GbPPj87H
         lXnbRb3UIFy1nDDMDkwLb0ZRN0pp5vnL/thvR4acZWTRFmXekkutPH7VqDvgkjrHbs7E
         VFBJtXDysAV1s6ZU1QN7y1NBYAWplByGYdjJCq2H4XU8HjuV5JPm70gEGKi67MM3Zwj2
         DjJOwmbeyyQU6qR/cK1U7/o68FNudxJqlK8BrxdMj36PPSsUx1PCWt+OnZYN+E1MYBUE
         XVnwWy53K9mbGQBTs9Hw6sc/EZM4N8AHJi1Ey7i/HeCXkFnP7v560h1MviPRpGfP3wg+
         fxUA==
X-Gm-Message-State: APjAAAVQo2Uu4dqqY3sBAnRvNmZkQdrfsKI4X1MQIqWZ/LF+NcMgiWfO
        mh/V9YCnZ+f/wZLsPDwhv1mL3g==
X-Google-Smtp-Source: APXvYqwLsrqAQku6UEZ+m75sX13ln6fLUNoETR2ZmPckprU0bqTzke9nFnndvHW2jpMVg425OyWE3w==
X-Received: by 2002:a17:90a:480a:: with SMTP id a10mr14637pjh.88.1578508990909;
        Wed, 08 Jan 2020 10:43:10 -0800 (PST)
Received: from google.com ([2620:15c:201:0:7f8c:9d6e:20b8:e324])
        by smtp.gmail.com with ESMTPSA id y7sm4734645pfb.139.2020.01.08.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 10:43:10 -0800 (PST)
Date:   Wed, 8 Jan 2020 10:43:05 -0800
From:   Satya Tangirala <satyat@google.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 0/9] Inline Encryption Support
Message-ID: <20200108184305.GA173657@google.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20200108140556.GB2896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108140556.GB2896@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jan 08, 2020 at 06:05:56AM -0800, Christoph Hellwig wrote:
> I haven't been able to deep dive into the details, but the structure
> of this still makes me very unhappy.
> 
> Most of it is related to the software fallback again.  Please split the
> fallback into a separate file, and also into a separate data structure.
> There is abslutely no need to have the overhead of the software only
> fields for the hardware case.
> 
The fallback actually is in a separate file, and the software only fields
are not allocated in the hardware case anymore, either - I should have
made that clear(er) in the coverletter.
> On the counter side I think all the core block layer code added should
> go into a single file instead of split into three with some odd
> layering.
> 
Alright, I'll look into this. I still think that the keyslot manager
should maybe go in a separate file because it does a specific, fairly
self contained task and isn't just block layer code - it's the interface
between the device drivers and any upper layer.
> Also what I don't understand is why this managed key-slots on a per-bio
> basis.  Wou;dn't it make a whole lot more sense to manage them on a
> struct request basis once most of the merging has been performed?
I don't immediately see an issue with making it work on a struct request
basis. I'll look into this more carefully.

Thanks!
Satya
