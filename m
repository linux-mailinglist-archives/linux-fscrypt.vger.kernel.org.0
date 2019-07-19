Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1886ECCD
	for <lists+linux-fscrypt@lfdr.de>; Sat, 20 Jul 2019 01:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbfGSXsG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 Jul 2019 19:48:06 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60293 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728247AbfGSXsG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 Jul 2019 19:48:06 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x6JNlxwn008493
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Jul 2019 19:48:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6F1A7420054; Fri, 19 Jul 2019 19:47:59 -0400 (EDT)
Date:   Fri, 19 Jul 2019 19:47:59 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] e2fsck: check for consistent encryption policies
Message-ID: <20190719234759.GC8149@mit.edu>
References: <20190718011325.19516-1-ebiggers@kernel.org>
 <621FA6A1-745D-43BA-A52A-4229902737BF@dilger.ca>
 <20190719231843.GH1422@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190719231843.GH1422@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 19, 2019 at 04:18:44PM -0700, Eric Biggers wrote:
> 
> That's correct.  I wanted to propose something simpler first to see what people
> thought, but yes if this is really a concern, what we should do is assign a u32
> id to each new encryption policy that is seen, and store just that id per inode.
> 
> To do that we need a proper map data structure for the policy => ID mapping,
> which as usual is nontrivial to do in C.  lib/ext2fs/rbtree.h could do, though.
> There's also lib/ext2fs/hashmap.c, but it doesn't implement resizing.

The fscrypt policy is only 12 bytes, so overhead of using an rbtree
(two 8 byte pointers) is about the same as its payload.  The number of
policies in a file system will typically be quite small (at most a few
dozen), usually under a dozen, and so it might be the simplest thing
to do is to keep a sorted list (in memcmp order), and then use a
binary search to do the lookups.

OTOH, since normally there will only be a small handful of policies in
use, we don't really care about the rbtree overhead, so if we just use
an rbtree to avoid open-coding another data structure (like we do in
lib/ext2fs/icount.c, et.al.), that's also find.

The other thing I'll note is that we only need the map in pass 1.
Once we've assigned a policy ID number to each encrypted inode, we
don't need it any more, since the only thing we really care about is
enforcing the parent::child relationship vis-a-vis fscrypt policies.

      		    		 	   	   - Ted



