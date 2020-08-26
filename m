Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3531253899
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Aug 2020 21:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHZTxz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Aug 2020 15:53:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46832 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgHZTxy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Aug 2020 15:53:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QJnoIc191551;
        Wed, 26 Aug 2020 19:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=IKfkbSvhoYnpe77AbyNHi7yNcBWPI3eU4ZQKcABaMNk=;
 b=Mp9E9laHvwmPMDNyMafepioCaKCEhw6fEslVHRLoj5gc6Tr9fTOr0jIKBJfTpUB9n4GV
 CKNjXwHkFpkeXLiFm0o6y75YIM4MOu6J4Tkjmf8fKrGeHLZflpncWZ3PFYFhsuGRblL6
 AjOpXzQ0/DBz6Jk9rppkDCTqr9EmldKObzIPgqB2R+q934GK//JAO8uplxyaImj8i8WP
 rxiegyDCmjQrTrJ48HP8pACGhhcxhZhBVAc+SfmOu5oCga1li6jJYOQrrW+HZiRquAo0
 86iPjDTT27tmS0VhUH568Pj2+7GYlFnXpscSxwt7IuehfqqxeY1RPZt8C+TunKaeDhUK wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbs2h3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 19:53:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QJof4X029515;
        Wed, 26 Aug 2020 19:51:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333ru0k44v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 19:51:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07QJpn27026129;
        Wed, 26 Aug 2020 19:51:49 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 12:51:49 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: IMA metadata format to support fs-verity
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20200826192403.GD2239109@gmail.com>
Date:   Wed, 26 Aug 2020 15:51:48 -0400
Cc:     linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E7A87987-AF41-42AC-8244-0D07AA68A6E7@oracle.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
 <20200826183116.GC2239109@gmail.com>
 <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
 <20200826192403.GD2239109@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260149
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



> On Aug 26, 2020, at 3:24 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> On Wed, Aug 26, 2020 at 02:56:45PM -0400, Chuck Lever wrote:
>>=20
>>> On Aug 26, 2020, at 2:31 PM, Eric Biggers <ebiggers@kernel.org> =
wrote:
>>>=20
>>> On Wed, Aug 26, 2020 at 10:13:43AM -0700, Chuck Lever wrote:
>>>> Hi Eric-
>>>>=20
>>>> I'm trying to construct a viable IMA metadata format (ie, what
>>>> goes into security.ima) to support Merkle trees.
>>>>=20
>>>> Rather than storing an entire Merkle tree per file, Mimi would
>>>> like to have a metadata format that can store the root hash of
>>>> a Merkle tree. Instead of reading the whole tree, an NFS client
>>>> (for example) would generate the parts of the file's fs-verity
>>>> Merkle tree on-demand. The tree itself would not be exposed or
>>>> transported by the NFS protocol.
>>>=20
>>> This won't work because you'd need to reconstruct the whole Merkle =
tree when
>>> reading the first byte from the file.  Check the fs-verity FAQ
>>> =
(https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#faq) =
where I
>>> explained this in more detail (fourth question).
>>=20
>> We agree there are inefficiencies with the proposed scheme. The
>> Merkle tree would be rehydrated at measurement time, and used at
>> read time to verify the results of each subsequent NFS READ.
>>=20
>> We assume that parts of the tree and parts of the file content
>> can be evicted from the client's memory at any time. So verifying
>> READ results may require rehydration of some or all of the Merkle
>> tree. If we're careful, eviction might avoid the higher levels of
>> the tree to prevent the need to read the whole file again.
>>=20
>> So, maybe we want to store the first level or two of the tree as
>> well? Obviously there is a limit to how much can be stored in an
>> extended attribute.
>=20
> That's going to be very inefficient, and difficult to handle the =
caching,
> preferential eviction, and constant tree rebuilding.

My focus is code signing. I'm expecting individual executables to
be under a few dozen megabytes in size, on average, and to change
infrequently or never (immutable). Configuration files, shell
scripts, and symlinks will be even smaller on average.

Thus I anticipate that the frequency of eviction should be pretty
small, and the client should be able to read the files in their
entirety quickly. Efficiency comes from reading each file as few
times as possible to maintain its Merkle tree. The cost of
measuring the file is amortized well if the file is used
frequently enough to keep its tree in the client's memory.

The inefficient case is a file that is large and used infrequently,
IIUC.


> IMO, the only model that really makes sense is one where the full tree =
is stored
> persistently.

Can you say more about why you believe that?


> Have you considered options for how that could be done in NFS?

We have.


> What NFS protocol modifications (if any) are in scope?

There are two ways to pull data via NFS. One is READ, which assumes
an arbitrarily large byte stream and the ability to seek in it. The
byte stream content is read in sections no larger than "rsize"
(typically 1MB or less). The client has various mechanisms to
detect when the file content has changed on the server, and can use
them to cache the file's content aggressively.

The other is attribute data, which is pulled in a single operation and
is therefore limited in size. There is no cache consistency scheme
for this type of data, so clients typically read it every time there
is an application request for it.

- We could define a named attribute that is a secondary byte stream
associated with a filehandle. It can be arbitrarily large and is
read piecemeal via NFS READ.

- We could define a pNFS layout that enables the storage of the tree
to be on some other storage service. It can be arbitrarily large and is
read piecemeal via NFS READ or some other operation (SCSI, NVMe, etc).

- We could define a new fattr4 attribute that stores metadata (that's
what I've been doing in prototype to store IMA metadata). It is read
and written in its entirety in a single operation.


>>>> Following up with the recent thread on linux-integrity, starting
>>>> here:
>>>>=20
>>>> =
https://lore.kernel.org/linux-integrity/1597079586.3966.34.camel@HansenPar=
tnership.com/t/#u
>>>>=20
>>>> I think the following will be needed.
>>>>=20
>>>> 1. The parameters for (re)constructing the Merkle tree:
>>>> - The name of the digest algorithm
>>>> - The unit size represented by each leaf in the tree
>>>> - The depth of the finished tree
>>>> - The size of the file
>>>> - Perhaps a salt value
>>>> - Perhaps the file's mtime at the time the hash was computed
>>>> - The root hash
>>>=20
>>> Well, the xattr would need to contain the same information as
>>> struct fsverity_enable_arg, the argument to FS_IOC_ENABLE_VERITY.
>>>=20
>>>> 2. A fingerprint of the signer:
>>>> - The name of the digest algorithm
>>>> - The digest of the signer's certificate
>>>>=20
>>>> 3. The signature
>>>> - The name of the signature algorithm
>>>> - The signature, computed over 1.
>>>=20
>>> I thought there was a desire to just use the existing =
"integrity.ima"
>>> signature format.
>>=20
>> I am very interested in using EVM_IMA_DIGSIG. However, there appears
>> to be a consensus that for cases like NFS, every readpage result =
needs
>> to be verified, just as fs-verity does it.
>>=20
>> I suppose measurement for an NFS file could involve verifying a
>> saved linear hash while at the same time constructing a Merkle tree
>> on the client?
>=20
> fs-verity is mostly just a way of hashing a file.  Can't IMA just =
continue to do
> its signatures in the same way, and just swap out the traditional full =
file hash
> with the fs-verity file hash (when it's enabled)?

Essentially that's what we're doing: inventing a new IMA metadata
format that stores a Merkle root hash instead of a linear hash.

The current IMA formats take a single parameter: which hash algo
to use. Merkle tree construction requires a larger set of parameters,
which is why we think a new metadata format is necessary.


> fs-verity does support its own signature mechanism, because people =
wanted a
> simple knob to set that makes the kernel verify and enforce signatures =
for all
> fs-verity files.  But it's not mandatory to use that.


--
Chuck Lever



