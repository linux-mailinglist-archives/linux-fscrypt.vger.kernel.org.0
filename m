Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4302DDC45
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 01:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbgLRAFx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 19:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgLRAFx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 19:05:53 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B84FC061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 16:05:13 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id w16so199341pga.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 16:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ftImLJzo43H5xhmSmjP4UoiWeHjvqDggI/0+orDetik=;
        b=lGUzz2DBxHqOZ3lDtOCCkd5RBICJjSiF7pJd7d7sVRkhLLTKqKGLKsCCQh83Y2DyRu
         R3Hp/kZrLyaW6w9dqBBrAVhEv3IN66sHWz9c/Bfw+5Z8wcu4NHMGbwIqL+wk5UMRsv4G
         I27gqRa/r18pf7SWXr6cl8quCCTDDBFrv6Y9/i2tGMl+BIJAT2A5z59eEJPIudq5dYWA
         IJgcSLsecYIDeumR/5soBqp8zY0vIS+8EjXWq+Macuep/4LhIjKbn9IPWV/0KIs+bLje
         4owXXvYNfFeizvCslb0wzsQlVgTwd3w8j2YI5Ya+v8nrsLjuDr2+4wZOAS2RB1GGddcr
         ABkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ftImLJzo43H5xhmSmjP4UoiWeHjvqDggI/0+orDetik=;
        b=EstKDUQO8ni1Q3QqBOXMF16vB69pe0DnV6YL7pXWfzFO5pWbgl4byQ5MbQfWUbDb5D
         P0wWJaSCBqleCSY3pi88cQtjRbx09fx+sb4h6tYd+BV0BnwMA4EOcxc9K1Ja7Eb/CtYa
         JrQAiV9D2ovr/smR5NT4J6UV84GK42gqzQJfQ4nh0xGbT11FlcRaWQoQAdf9+c0zeXf3
         CI6NaXAX/9JUSZYXXHc5WDHE9+QGX56p+/L92l8/HhdHlDIOprzUPcTPKMDZxO7vllm6
         HUalbNJvZSk5tE19DAZ/hNPvq9AqD8ia7H0bgT9RWiCy9P8zoV8lF01Np/ABvRJGLu+t
         iNlQ==
X-Gm-Message-State: AOAM532WXqqt/ZOzW+RQeM0aBeHWRBP+jiSm3pmD49NC4ceBz21TecL2
        v+/AlWQoCVnnKIR1R42FrDtCSg==
X-Google-Smtp-Source: ABdhPJy7HG5nAm/M1+v6tcuBGzjRBKasXQMAtPvNHhZ0NDa8zYyozbj7OZjyp+1R37ig9gxk7wnJ8g==
X-Received: by 2002:a62:ac09:0:b029:1a9:dd65:2f46 with SMTP id v9-20020a62ac090000b02901a9dd652f46mr1674893pfe.15.1608249912162;
        Thu, 17 Dec 2020 16:05:12 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id 14sm4578052pfi.131.2020.12.17.16.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 16:05:11 -0800 (PST)
Date:   Fri, 18 Dec 2020 00:05:07 +0000
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 0/3] add support for metadata encryption to F2FS
Message-ID: <X9vyM0jb91Q7aBJW@google.com>
References: <20201217150435.1505269-1-satyat@google.com>
 <X9uesUH1oetyyoA0@mit.edu>
 <X9vEwgHlURxvxqiM@google.com>
 <X9vrA/h8et4japdI@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9vrA/h8et4japdI@mit.edu>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 06:34:27PM -0500, Theodore Y. Ts'o wrote:
> On Thu, Dec 17, 2020 at 08:51:14PM +0000, Satya Tangirala wrote:
> > On Thu, Dec 17, 2020 at 01:08:49PM -0500, Theodore Y. Ts'o wrote:
> > > On Thu, Dec 17, 2020 at 03:04:32PM +0000, Satya Tangirala wrote:
> > > > This patch series adds support for metadata encryption to F2FS using
> > > > blk-crypto.
> > > 
> > > Is there a companion patch series needed so that f2fstools can
> > > check/repair a file system with metadata encryption enabled?
> > > 
> > > 	       	    	   	- Ted
> > Yes! It's at
> > https://lore.kernel.org/linux-f2fs-devel/20201217151013.1513045-1-satyat@google.com/
> 
> Cool, I've been meaning to update f2fs-tools in Debian, and including
> these patches will allow us to generate {kvm,gce,android}-xfstests
> images with this support.  I'm hoping to get to it sometime betweeen
> Christmas and New Year's.
> 
> I guess there will need to be some additional work needed to create
> the f2fs image with a fixed keys for a particular file system in
> xfstests-bld, and then mounting and checking said image with the
> appropriatre keys as well.   Is that something you've put together?
> 
I did put something together that sets up metadata encryption on the disks
used by kvm-xfstests. The main code changes were to add a fixed
metadata encryption key with keyctl, and export MKFS_OPTIONS with the
metadata encryption options.

The mkfs options are the only options that need direct modification because
the rest of the tools (fsck/dump etc.) automatically do the right thing if
the FS superblock has the metadata encryption options. But the rest of the
tools do need the metadata encryption key to be present, and some
xfstests/other parts of the harness code clear the keyrings directly, so I
had a few more hacky changes to re-add the keys when they're cleared.
Some more hacky changes were needed because some xfstests override
MKFS_OPTIONS. I'll be happy to send what I have to you/put it up somewhere.
I'll also try to clean up the code a little, but my knowledge of xfstests
is definitely limited so it might take a little while.
> Cheers,
> 
> 						- Ted
