Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA002537B4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Aug 2020 20:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHZS6v (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 14:58:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgHZS6u (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 14:58:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QIshkT088961;
        Wed, 26 Aug 2020 18:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Wxz2gOkFBISIW6EC1ksXYVaYQ/7oA0TRswt7w/J6XDE=;
 b=vOom8bouG59nZu0SpZ/EiPOerbqsHBYySIQr06D9jHpR9tba0HdWSMIapGjx2YES6ATY
 YHAr1AVNi3gi2eMf8s6P7I6rdE5RpwVWGSLABoapKWV3d4bXtqyh3lZwUG3AIHfPWYbg
 A/e8yQ3t8pJZES9X5fNfHq8XIPg/hoYI/hSLa9N02G7cm4+Kvk/j4sueX9JjwuVGtNJF
 MqVQJQLREkR1RrVGkkZ+u4QhFPUEX4DEpCxnGAdvO4hN/dPDZ5wyrTggrzGrieta5Bho
 PkmBCHIQuLOZDNCixkpifHvYPBKpTDsfIUGysUgrAPdiHdEvMTJEgQ61GlIqA8J2Jq6u Ow== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 335gw8447j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 18:58:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QIser8044815;
        Wed, 26 Aug 2020 18:56:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 333ru0h6du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 18:56:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QIuli9016883;
        Wed, 26 Aug 2020 18:56:47 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 11:56:46 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: IMA metadata format to support fs-verity
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200826183116.GC2239109@gmail.com>
Date:   Wed, 26 Aug 2020 14:56:45 -0400
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
 <20200826183116.GC2239109@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260140
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



> On Aug 26, 2020, at 2:31 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Wed, Aug 26, 2020 at 10:13:43AM -0700, Chuck Lever wrote:
>> Hi Eric-
>>=20
>> I'm trying to construct a viable IMA metadata format (ie, what
>> goes into security.ima) to support Merkle trees.
>>=20
>> Rather than storing an entire Merkle tree per file, Mimi would
>> like to have a metadata format that can store the root hash of
>> a Merkle tree. Instead of reading the whole tree, an NFS client
>> (for example) would generate the parts of the file's fs-verity
>> Merkle tree on-demand. The tree itself would not be exposed or
>> transported by the NFS protocol.
>=20
> This won't work because you'd need to reconstruct the whole Merkle =
tree when
> reading the first byte from the file.  Check the fs-verity FAQ
> (https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#faq) =
where I
> explained this in more detail (fourth question).

We agree there are inefficiencies with the proposed scheme. The
Merkle tree would be rehydrated at measurement time, and used at
read time to verify the results of each subsequent NFS READ.

We assume that parts of the tree and parts of the file content
can be evicted from the client's memory at any time. So verifying
READ results may require rehydration of some or all of the Merkle
tree. If we're careful, eviction might avoid the higher levels of
the tree to prevent the need to read the whole file again.

So, maybe we want to store the first level or two of the tree as
well? Obviously there is a limit to how much can be stored in an
extended attribute.


>> Following up with the recent thread on linux-integrity, starting
>> here:
>>=20
>>  =
https://lore.kernel.org/linux-integrity/1597079586.3966.34.camel@HansenPar=
tnership.com/t/#u
>>=20
>> I think the following will be needed.
>>=20
>> 1. The parameters for (re)constructing the Merkle tree:
>> - The name of the digest algorithm
>> - The unit size represented by each leaf in the tree
>> - The depth of the finished tree
>> - The size of the file
>> - Perhaps a salt value
>> - Perhaps the file's mtime at the time the hash was computed
>> - The root hash
>=20
> Well, the xattr would need to contain the same information as
> struct fsverity_enable_arg, the argument to FS_IOC_ENABLE_VERITY.
>=20
>> 2. A fingerprint of the signer:
>> - The name of the digest algorithm
>> - The digest of the signer's certificate
>>=20
>> 3. The signature
>> - The name of the signature algorithm
>> - The signature, computed over 1.
>=20
> I thought there was a desire to just use the existing "integrity.ima"
> signature format.

I am very interested in using EVM_IMA_DIGSIG. However, there appears
to be a consensus that for cases like NFS, every readpage result needs
to be verified, just as fs-verity does it.

I suppose measurement for an NFS file could involve verifying a
saved linear hash while at the same time constructing a Merkle tree
on the client?


>> There has been some controversy about whether to allow the
>> metadata to be unsigned. It can't ever be unsigned for NFS files,
>> but some feel that on a physically secure local-only set up,
>> signatures could be unnecessary overhead. I'm not convinced, and
>> believe the metadata should always be signed: that's the only
>> way to guarantee end-to-end integrity, which includes protection
>> of the content's provenance, no matter how it is stored.
>=20
> Are you looking for integrity-only protection (protection against =
accidental
> modification), or also for authenticity protection (protection against
> malicicous modifications)?  For authenticity, you have to verify the =
file's hash
> against something you trust.  A signature is the usual way to do that.

My interest is content provenance (authenticity), where both a
digest and its signature are required. I can't speak for how
others want to use this metadata.


--
Chuck Lever



