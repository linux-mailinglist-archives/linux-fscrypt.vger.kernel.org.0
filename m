Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D684C7E5F1B
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Nov 2023 21:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjKHUZz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Nov 2023 15:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjKHUZy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Nov 2023 15:25:54 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AC2213F
        for <linux-fscrypt@vger.kernel.org>; Wed,  8 Nov 2023 12:25:52 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-77bac408851so102615485a.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Nov 2023 12:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1699475152; x=1700079952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jK1nJO3A2bdbcDtSiZJ/FINWoUSICdNOK+5Z8W44+94=;
        b=BbC9HjwQaAVk9OOyefV64MqE3CXM2OKa/EYeIoB4Ddz7qDPssDQkBXkdpMe3DgdUMe
         DUQ7QX0/01T2dMsCKd1sGD0DdLkI6oy4h8NF8/8JRCA/AIzjiwCMnTkg4+mQhIwii4lJ
         9RRgHkJBkS/9CODuA+dprCwWZ8rd6ckh+uQPBNGWCTMTkrXb4MbiJtalpCpHYoFOIeBd
         HqS3pi3CBe4Rue5ikiGnrcZr3RkOMAI6/RT8k5Ff4Hpc5YtOsvoIiZrOWybaTGk7cflJ
         DX3vgcAL/XeynWmixdrBx3+eizZ95gS6S2w1gsBpfsV8PsGusjHV6wZp5HWXBUK2gYIQ
         cKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699475152; x=1700079952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jK1nJO3A2bdbcDtSiZJ/FINWoUSICdNOK+5Z8W44+94=;
        b=ltWf8f7UKR6A/j+CJqc7Y2yOQAxNHDrT92l1wJrqo/9mm6u/lLA+cwffMMQNXkRnf5
         kyziOmLQVD2BTRM99NlBelWT38h3l00Rs648kW8qEjvmj3BOdkogpV/eD9VhQycGn9HW
         bgVJ8jSDJJ1maeBhzGeiKWIr6ABxS8SiOemKIyja2OJxmB4iBLR+Qd/E/WxX7RkeefP5
         4ufF1jBnzGd57aeJfJHENXkPiBS33VJ1UNlfzTfH4rvRMKaLjCEBD2sn7VH8qpJ0zm01
         wqG89AUEbBV8/+Ld896xgT4cZkNgpoNOfPIOifDPT+bUYIL7LLjYZSfojnaLspSR3dfL
         5R9w==
X-Gm-Message-State: AOJu0YzNf9xp8rfMJ8YuDoqRyD4zjsxqhnIAdaL3fpEkxyoFyH5Cylq+
        c05EAT+XgKIoWtDIZM84dLV15w==
X-Google-Smtp-Source: AGHT+IEIJIogXASMFwyMazJN0/00lMzSLQnx6+b8+pjRO0r+W1pyhri4FzCdaCazZdXs5hi6d9s/xQ==
X-Received: by 2002:a05:620a:40c6:b0:775:92ac:a3d6 with SMTP id g6-20020a05620a40c600b0077592aca3d6mr4285567qko.14.1699475151873;
        Wed, 08 Nov 2023 12:25:51 -0800 (PST)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id vq25-20020a05620a559900b007756c0853a5sm1395858qkn.58.2023.11.08.12.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Nov 2023 12:25:51 -0800 (PST)
Date:   Wed, 8 Nov 2023 15:25:50 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/12] fstests: split generic/580 into two tests
Message-ID: <20231108202550.GA548237@perftesting>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <ecf95cca70aa11c64455893ea823ec8de0249cf5.1696969376.git.josef@toxicpanda.com>
 <7cba2927-5636-4039-9e76-f01a5b86c108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cba2927-5636-4039-9e76-f01a5b86c108@oracle.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Nov 02, 2023 at 07:42:50PM +0800, Anand Jain wrote:
> On 10/11/23 04:26, Josef Bacik wrote:
> > generic/580 tests both v1 and v2 encryption policies, however btrfs only
> > supports v2 policies.  Split this into two tests so that we can get the
> > v2 coverage for btrfs.
> 
> Instead of duplicating the test cases for v1 and v2 encryption policies,
> can we check the supported version and run them accordingly within a
> single test case?
> 
> The same applies 10 and 11/12 patches as well.

This will be awkward for file systems that support both, hence the split.  I
don't love suddenly generating a bunch of new tests, but this seems like the
better option since btrfs is the only file system that only supports v2, and
everybody else supports everything.  Thanks,

Josef
