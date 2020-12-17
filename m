Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEED32DDBE8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 00:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732063AbgLQXfn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 18:35:43 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37669 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732059AbgLQXfn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 18:35:43 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BHNYRol004556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 18:34:28 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 98868420280; Thu, 17 Dec 2020 18:34:27 -0500 (EST)
Date:   Thu, 17 Dec 2020 18:34:27 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Satya Tangirala <satyat@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 0/3] add support for metadata encryption to F2FS
Message-ID: <X9vrA/h8et4japdI@mit.edu>
References: <20201217150435.1505269-1-satyat@google.com>
 <X9uesUH1oetyyoA0@mit.edu>
 <X9vEwgHlURxvxqiM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9vEwgHlURxvxqiM@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 08:51:14PM +0000, Satya Tangirala wrote:
> On Thu, Dec 17, 2020 at 01:08:49PM -0500, Theodore Y. Ts'o wrote:
> > On Thu, Dec 17, 2020 at 03:04:32PM +0000, Satya Tangirala wrote:
> > > This patch series adds support for metadata encryption to F2FS using
> > > blk-crypto.
> > 
> > Is there a companion patch series needed so that f2fstools can
> > check/repair a file system with metadata encryption enabled?
> > 
> > 	       	    	   	- Ted
> Yes! It's at
> https://lore.kernel.org/linux-f2fs-devel/20201217151013.1513045-1-satyat@google.com/

Cool, I've been meaning to update f2fs-tools in Debian, and including
these patches will allow us to generate {kvm,gce,android}-xfstests
images with this support.  I'm hoping to get to it sometime betweeen
Christmas and New Year's.

I guess there will need to be some additional work needed to create
the f2fs image with a fixed keys for a particular file system in
xfstests-bld, and then mounting and checking said image with the
appropriatre keys as well.   Is that something you've put together?

Cheers,

						- Ted
